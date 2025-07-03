import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/mention_event.dart';
import '../view_model/mention_state.dart';
import '../view_model/mention_view_model.dart';

class PostBodyField extends StatefulWidget {
  final TextEditingController controller;

  const PostBodyField({super.key, required this.controller});

  @override
  State<PostBodyField> createState() => _PostBodyFieldState();
}

class _PostBodyFieldState extends State<PostBodyField> {
  late FocusNode _focusNode;
  OverlayEntry? _overlayEntry;
  late final MentionViewModel _mentionBloc;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _mentionBloc = context.read<MentionViewModel>();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    // A small delay to allow tap events on the overlay to register before hiding.
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!_focusNode.hasFocus) {
        _mentionBloc.add(const MentionUserSelected(''));
      }
    });
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    final cursorPos = widget.controller.selection.baseOffset;

    if (cursorPos > 0) {
      final lastAt = text.lastIndexOf('@', cursorPos - 1);
      // A mention is valid if '@' is found and it's at the start of the text
      // or preceded by a space (i.e., not part of an email).
      final isMentionTrigger = lastAt != -1 && (lastAt == 0 || text[lastAt - 1] == ' ');

      if (isMentionTrigger) {
        final query = text.substring(lastAt + 1, cursorPos);
        // If the user types a space, the mention is considered complete or invalid.
        if (query.contains(' ')) {
          _mentionBloc.add(const MentionUserSelected(''));
          return;
        }
        // If the mention state isn't active yet, activate it.
        if (!_mentionBloc.state.mentionActive) {
          _mentionBloc.add(MentionSymbolInserted(lastAt));
        }
        // Dispatch text change to filter suggestions.
        _mentionBloc.add(MentionTextChanged(query));
        return;
      }
    }
    // If no valid mention trigger is found, ensure the state is reset.
    if (_mentionBloc.state.mentionActive) {
      _mentionBloc.add(const MentionUserSelected(''));
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        // Provide the BLoC instance to the overlay's widget tree.
        return BlocProvider.value(
          value: _mentionBloc,
          child: Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom + 56,
            left: 20,
            right: 20,
            child: _MentionDropdown(onUserSelected: _onUserSelected),
          ),
        );
      },
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onUserSelected(String username) {
    final mentionState = _mentionBloc.state;
    if (mentionState.mentionStartIndex == null) return;

    final start = mentionState.mentionStartIndex!;
    // Use the current cursor position to correctly replace the typed text.
    final end = widget.controller.selection.baseOffset;
    final before = widget.controller.text.substring(0, start);
    // Get the text after the mention query.
    final after = widget.controller.text.substring(end);

    // Replace the query with the selected username and add a space.
    final newText = '$before@$username $after';
    widget.controller.text = newText;

    // Move the cursor to the position right after the inserted mention.
    final newCursorPos = start + username.length + 2; // @ + username + space
    widget.controller.selection = TextSelection.collapsed(offset: newCursorPos);

    // The BLoC event will trigger the overlay to be removed via the BlocListener.
    _mentionBloc.add(MentionUserSelected(username));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MentionViewModel, MentionState>(
      listener: (context, state) {
        if (state.mentionActive && _overlayEntry == null) {
          _showOverlay();
        } else if (!state.mentionActive && _overlayEntry != null) {
          _removeOverlay();
        }
      },
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          hintText: 'Share your thoughts...',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }
}

/// The dropdown widget that shows the list of user suggestions.
class _MentionDropdown extends StatelessWidget {
  final void Function(String username) onUserSelected;

  const _MentionDropdown({required this.onUserSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: BlocBuilder<MentionViewModel, MentionState>(
        builder: (context, state) {
          if (!state.mentionActive || state.suggestions.isEmpty) {
            return const SizedBox.shrink();
          }

          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            // *** THE CHANGE IS HERE: Using ListView.separated ***
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              shrinkWrap: true,
              itemCount: state.suggestions.length,
              itemBuilder: (context, index) {
                final user = state.suggestions[index];

                // Logic to build the leading avatar/icon based on the user type.
                Widget leadingWidget;
                if (user.isHighlight) {
                  leadingWidget = CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[400]!, width: 1.5),
                        ),
                      ),
                    ),
                  );
                } else {
                  leadingWidget = CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImageUrl!),
                    onBackgroundImageError: (_, __) {}, // Handles image loading errors gracefully.
                    backgroundColor: Colors.grey[200],
                  );
                }

                // Logic to build the title, adding '@' only for the highlight option.
                Widget titleWidget = user.isHighlight
                    ? Text('@${user.username}', style: const TextStyle(fontWeight: FontWeight.bold))
                    : Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold));

                return ListTile(
                  leading: leadingWidget,
                  title: titleWidget,
                  subtitle: Text(
                    user.subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  onTap: () => onUserSelected(user.username),
                );
              },
              // This builder creates the separator between each item.
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[200],
                  indent: 72, // Indent to align with the text, after the avatar
                  endIndent: 16,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

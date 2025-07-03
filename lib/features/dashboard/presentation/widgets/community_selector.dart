import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Community {
  final String name;
  final String members;
  final String profileImageUrl;

  const Community({
    required this.name,
    required this.members,
    required this.profileImageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Community &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

// The widget is now stateful to manage the overlay
class CommunitySelector extends StatefulWidget {
  final List<Community> communities;
  final Community? selectedCommunity;
  final ValueChanged<Community?> onChanged;

  const CommunitySelector({
    super.key,
    required this.communities,
    required this.selectedCommunity,
    required this.onChanged,
  });

  @override
  State<CommunitySelector> createState() => _CommunitySelectorState();
}

class _CommunitySelectorState extends State<CommunitySelector> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  /// Toggles the visibility of the custom dropdown overlay.
  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  /// Creates and displays the custom dropdown overlay.
  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 8.0), // Position below the selector
            child: _CommunityDropdown(
              communities: widget.communities,
              onCommunitySelected: (community) {
                widget.onChanged(community);
                _removeOverlay(); // Close overlay on selection
              },
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  /// Removes the overlay from the screen.
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    // This CompositedTransformTarget is used to link the overlay's position
    // to this widget's position.
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              // Display the selected community's avatar or a default icon
              widget.selectedCommunity != null
                  ? CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(widget.selectedCommunity!.profileImageUrl),
                    )
                  : const CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFFEEEEEE),
                      child: Icon(LucideIcons.users, size: 14, color: Colors.black54),
                    ),
              const SizedBox(width: 12),
              // Display the selected community's name or a hint text
              Expanded(
                child: Text(
                  widget.selectedCommunity?.name ?? "Choose a community",
                  style: TextStyle(
                    fontWeight: widget.selectedCommunity != null ? FontWeight.w500 : FontWeight.normal,
                    color: widget.selectedCommunity != null ? Colors.black87 : Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(LucideIcons.chevronDown, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}

/// The custom dropdown widget, styled exactly like the mention dropdown.
class _CommunityDropdown extends StatelessWidget {
  final List<Community> communities;
  final void Function(Community) onCommunitySelected;

  const _CommunityDropdown({
    required this.communities,
    required this.onCommunitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 250),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          shrinkWrap: true,
          itemCount: communities.length,
          itemBuilder: (context, index) {
            final community = communities[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(community.profileImageUrl),
                backgroundColor: Colors.grey[200],
              ),
              title: Text(community.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                community.members,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              onTap: () => onCommunitySelected(community),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
              indent: 72,
              endIndent: 16,
            );
          },
        ),
      ),
    );
  }
}

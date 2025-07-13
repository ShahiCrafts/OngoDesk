import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/create_post_event.dart';
import '../../view_model/create_post_view_model.dart';

class CommunitySelector extends StatelessWidget {
  // FIX: Renamed for clarity. This is the name to display on the button.
  final String selectedCommunityName;
  // FIX: Renamed for clarity. This callback is only for selecting a community.
  final VoidCallback onSelectCommunity;

  const CommunitySelector({
    super.key,
    required this.selectedCommunityName,
    required this.onSelectCommunity,
  });

  @override
  Widget build(BuildContext context) {
    // We get the full state to manage the visibility toggle icon.
    final state = context.watch<CreatePostViewModel>().state;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            // Use the specific callback for selecting a community.
            onTap: onSelectCommunity,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(48),
              ),
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFFF5C00),
                    foregroundColor: Colors.white,
                    child: Text('o/'),
                  ),
                  const SizedBox(width: 12),
                  // Display the name passed from the parent widget.
                  Text(
                    selectedCommunityName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.unfold_more),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // This visibility toggle logic remains the same.
        Tooltip(
          message: state.isPublic ? 'Public Post' : 'Admin Only',
          child: GestureDetector(
            onTap: () =>
                context.read<CreatePostViewModel>().add(ToggleVisibility()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: state.isPublic
                    ? const Color(0xFFFFF3E8)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: Border.all(
                  color: state.isPublic
                      ? const Color(0xFFFF5C00)
                      : Colors.grey.shade400,
                ),
              ),
              child: Icon(
                state.isPublic ? Icons.public : Icons.lock,
                color: state.isPublic
                    ? const Color(0xFFFF5C00)
                    : Colors.grey.shade700,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
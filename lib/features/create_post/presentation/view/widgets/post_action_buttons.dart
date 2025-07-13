import 'package:flutter/material.dart';
import '../../view_model/create_post_state.dart';

class PostActionButtons extends StatelessWidget {
  final CreatePostState state;
  final VoidCallback onFetchLocation;
  final VoidCallback onCreateEvent;
  final VoidCallback onTagPeople;

  const PostActionButtons({
    super.key,
    required this.state,
    required this.onFetchLocation,
    required this.onCreateEvent,
    required this.onTagPeople,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionButton(
          context,
          Icons.event,
          'Create Event',
          onCreateEvent,
        ),
        _buildActionButton(
          context,
          Icons.person_add_alt_1,
          'Tag People',
          onTagPeople,
        ),
        _buildActionButton(
          context,
          state.isFetchingLocation ? null : Icons.location_on_outlined,
          state.isFetchingLocation ? 'Fetching...' : 'Use Current Location',
          onFetchLocation,
          isLoading: state.isFetchingLocation,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData? icon,
    String label,
    VoidCallback onTap, {
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2.0, color: Color(0xFFFF5C00)),
              )
            else
              Icon(icon, size: 18, color: Colors.grey[800]),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
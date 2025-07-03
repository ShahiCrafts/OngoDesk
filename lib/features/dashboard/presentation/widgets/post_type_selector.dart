import 'package:flutter/material.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/post_type.dart';

class PostTypeCard extends StatelessWidget {
  final PostType postType;
  final bool isSelected;
  final VoidCallback onTap;

  const PostTypeCard({
    super.key,
    required this.postType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFFFF5C00);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? brandColor : Colors.grey[200]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? brandColor.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  postType.icon,
                  size: 20,
                  color: isSelected ? brandColor : Colors.black87,
                ),
                const SizedBox(width: 8),
                Text(
                  postType.label,
                  style: TextStyle(
                    color: isSelected ? brandColor : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              postType.subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

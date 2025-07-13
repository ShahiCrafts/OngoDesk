import 'package:flutter/material.dart';

class PostAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onPost;

  const PostAppBar({super.key, required this.onPost});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close),
      ),
      title: const Text(
        'Create Post',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      actions: [
        TextButton(
          onPressed: onPost,
          child: const Text(
            'Post',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF5C00),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
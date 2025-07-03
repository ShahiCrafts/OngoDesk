// lib/features/dashboard/presentation/widgets/post_bottom_toolbar.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PostBottomToolbar extends StatelessWidget {
  final VoidCallback? onAddImage;
  final VoidCallback? onAddVideo;
  final VoidCallback? onAttachLink;
  final VoidCallback? onMentionUser;
  final VoidCallback? onMarkdownHelp;

  const PostBottomToolbar({
    super.key,
    this.onAddImage,
    this.onAddVideo,
    this.onAttachLink,
    this.onMentionUser,
    this.onMarkdownHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.0,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(icon: const Icon(LucideIcons.image), onPressed: onAddImage, tooltip: 'Add image'),
              IconButton(icon: const Icon(LucideIcons.video), onPressed: onAddVideo, tooltip: 'Add video'),
              IconButton(icon: const Icon(LucideIcons.link), onPressed: onAttachLink, tooltip: 'Attach link'),
              IconButton(icon: const Icon(LucideIcons.atSign), onPressed: onMentionUser, tooltip: 'Mention user'),
              const Spacer(),
              TextButton(
                onPressed: onMarkdownHelp,
                child: Row(
                  children: [
                    const Icon(LucideIcons.helpCircle, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "Markdown",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

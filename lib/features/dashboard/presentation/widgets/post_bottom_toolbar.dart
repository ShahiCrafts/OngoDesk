import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PostBottomToolbar extends StatelessWidget {
  final VoidCallback? onAddImage;
  final VoidCallback? onAddVideo;
  // CHANGED: Renamed callbacks for clarity
  final VoidCallback? onAddDiscussion;
  final VoidCallback? onAddPoll;
  final VoidCallback? onMarkdownHelp;

  const PostBottomToolbar({
    super.key,
    this.onAddImage,
    this.onAddVideo,
    // CHANGED: Updated constructor parameters
    this.onAddDiscussion,
    this.onAddPoll,
    this.onMarkdownHelp,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1.0,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(icon: const Icon(LucideIcons.image), onPressed: onAddImage),
              IconButton(icon: const Icon(LucideIcons.video), onPressed: onAddVideo),
              // --- ICON CHANGES START HERE ---
              // REPLACED: Link icon is now a discussion icon
              IconButton(icon: const Icon(Icons.forum_outlined), onPressed: onAddDiscussion),
              // REPLACED: Mention icon is now a poll icon
              IconButton(icon: const Icon(LucideIcons.list), onPressed: onAddPoll),
              // --- ICON CHANGES END HERE ---
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

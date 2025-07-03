// lib/features/dashboard/presentation/widgets/post_type.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum PostType { discussion, event, issue, poll }

extension PostTypeExtension on PostType {
  String get label {
    switch (this) {
      case PostType.discussion:
        return 'Discussion';
      case PostType.event:
        return 'Event';
      case PostType.issue:
        return 'Issue';
      case PostType.poll:
        return 'Poll';
    }
  }

  IconData get icon {
    switch (this) {
      case PostType.discussion:
        return LucideIcons.messageSquare;
      case PostType.event:
        return LucideIcons.calendar;
      case PostType.issue:
        return LucideIcons.shieldAlert;
      case PostType.poll:
        return LucideIcons.barChart3;
    }
  }

  String get subtitle {
    switch (this) {
      case PostType.discussion:
        return 'Share thoughts or ask questions.';
      case PostType.event:
        return 'Organize a meeting or gathering.';
      case PostType.issue:
        return 'Report a problem or concern.';
      case PostType.poll:
        return 'Create a survey to get opinions.';
    }
  }
}

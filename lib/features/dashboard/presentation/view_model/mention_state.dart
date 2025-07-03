import 'package:equatable/equatable.dart';
import 'mention_view_model.dart'; // Import the file where User is defined

class MentionState extends Equatable {
  final bool mentionActive; // Is mention dropdown active?
  final int? mentionStartIndex; // Where "@" was inserted
  final List<User> suggestions; // User suggestions filtered by typed text

  const MentionState({
    this.mentionActive = false,
    this.mentionStartIndex,
    this.suggestions = const [],
  });

  MentionState copyWith({
    bool? mentionActive,
    int? mentionStartIndex,
    List<User>? suggestions,
    // Helper to reset mentionStartIndex to null
    bool resetMentionStartIndex = false,
  }) {
    return MentionState(
      mentionActive: mentionActive ?? this.mentionActive,
      mentionStartIndex: resetMentionStartIndex ? null : mentionStartIndex ?? this.mentionStartIndex,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  @override
  List<Object?> get props => [mentionActive, mentionStartIndex, suggestions];
}

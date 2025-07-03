import 'package:equatable/equatable.dart';

abstract class MentionEvent extends Equatable {
  const MentionEvent();

  @override
  List<Object?> get props => [];
}

// User clicked the @ button or typed @ manually at position
class MentionSymbolInserted extends MentionEvent {
  final int cursorPosition;

  const MentionSymbolInserted(this.cursorPosition);

  @override
  List<Object?> get props => [cursorPosition];
}

// User typed text in body to filter suggestions
class MentionTextChanged extends MentionEvent {
  final String text;

  const MentionTextChanged(this.text);

  @override
  List<Object?> get props => [text];
}

// User selected a user from mention suggestions
class MentionUserSelected extends MentionEvent {
  final String username;

  const MentionUserSelected(this.username);

  @override
  List<Object?> get props => [username];
}

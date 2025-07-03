import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mention_event.dart';
import 'mention_state.dart';

// Updated User model to include subtitle and a highlight flag
class User extends Equatable {
  final String username;
  final String? profileImageUrl; // Nullable for the highlight case
  final String subtitle;
  final bool isHighlight;

  const User({
    required this.username,
    this.profileImageUrl,
    required this.subtitle,
    this.isHighlight = false,
  });

  @override
  List<Object?> get props => [username, profileImageUrl, subtitle, isHighlight];
}

// Updated dummy user list to match the new design
final List<User> dummyUsers = [
  const User(
    username: 'highlight',
    subtitle: 'Some friends might receive notifications',
    isHighlight: true,
  ),
  const User(
    username: 'Manish Mahara',
    profileImageUrl: 'https://placehold.co/100x100/212121/FFFFFF?text=M',
    subtitle: 'Friend',
  ),
  const User(
    username: 'Jerr Ry',
    profileImageUrl: 'https://placehold.co/100x100/000000/FFFFFF?text=J',
    subtitle: 'Profile · 1.9K followers',
  ),
  const User(
    username: 'alice',
    profileImageUrl: 'https://placehold.co/100x100/E91E63/FFFFFF?text=A',
    subtitle: 'Community Member',
  ),
  const User(
    username: 'bob',
    profileImageUrl: 'https://placehold.co/100x100/3F51B5/FFFFFF?text=B',
    subtitle: 'Community Member',
  ),
];

class MentionViewModel extends Bloc<MentionEvent, MentionState> {
  MentionViewModel() : super(const MentionState()) {
    on<MentionSymbolInserted>(_onMentionSymbolInserted);
    on<MentionTextChanged>(_onMentionTextChanged);
    on<MentionUserSelected>(_onMentionUserSelected);
  }

  void _onMentionSymbolInserted(
      MentionSymbolInserted event, Emitter<MentionState> emit) {
    emit(state.copyWith(
      mentionActive: true,
      mentionStartIndex: event.cursorPosition,
      suggestions: dummyUsers,
    ));
  }

  void _onMentionTextChanged(
      MentionTextChanged event, Emitter<MentionState> emit) {
    final filter = event.text.toLowerCase();
    
    // The @highlight option should only show when the query is empty or "h", "hi" etc.
    if (filter.isEmpty) {
       emit(state.copyWith(suggestions: dummyUsers));
    } else {
       final filteredUsers = dummyUsers
        .where((user) => user.username.toLowerCase().contains(filter))
        .toList();
       emit(state.copyWith(suggestions: filteredUsers));
    }
  }

  void _onMentionUserSelected(
      MentionUserSelected event, Emitter<MentionState> emit) {
    emit(state.copyWith(
      mentionActive: false,
      resetMentionStartIndex: true,
      suggestions: [],
    ));
  }
}

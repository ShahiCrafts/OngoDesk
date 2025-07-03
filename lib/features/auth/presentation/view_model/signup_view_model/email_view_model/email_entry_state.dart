import 'package:equatable/equatable.dart';

enum EmailFormStatus { initial, submitting, success, failure }

class EmailEntryState extends Equatable {
  final String email;
  final EmailFormStatus status;
  final bool privacyPolicyAgreed;

  const EmailEntryState({
    this.email = '',
    this.status = EmailFormStatus.initial,
    this.privacyPolicyAgreed = false,
  });

  factory EmailEntryState.initial() {
    return EmailEntryState(
      email: '',
      status: EmailFormStatus.initial,
      privacyPolicyAgreed: false,
    );
  }

  EmailEntryState copyWith({
    String? email,
    EmailFormStatus? status,
    bool? privacyPolicyAgreed,
  }) {
    return EmailEntryState(
      email: email ?? this.email,
      status: status ?? this.status,
      privacyPolicyAgreed: privacyPolicyAgreed ?? this.privacyPolicyAgreed,
    );
  }

  @override
  List<Object?> get props => [email, status, privacyPolicyAgreed];
}

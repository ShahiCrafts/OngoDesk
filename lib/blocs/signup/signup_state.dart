import 'package:equatable/equatable.dart';

enum EmailFormStatus { initial, submitting, success, failure }

class SignupState extends Equatable {
  final String email;
  final bool value;
  final EmailFormStatus emailFormStatus;
  final String? message;

  const SignupState({
    this.email = '',
    this.value = false,
    this.emailFormStatus = EmailFormStatus.initial,
    this.message
  });

  SignupState copyWith({
    String? email,
    bool? value,
    EmailFormStatus? emailFormStatus,
    String? message
  }) {
    return SignupState(
      email: email ?? this.email,
      value: value ?? this.value,
      emailFormStatus: emailFormStatus ?? this.emailFormStatus,
      message: message ?? this.message
    );
  }

  @override
  List<Object?> get props => [
    email,
    value,
    emailFormStatus,
    message
  ];
}
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class TogglePasswordVisibility extends LoginEvent {}

class RememberMeToggled extends LoginEvent {
  final bool value;

  const RememberMeToggled(this.value);

  @override
  List<Object?> get props => [value];
}

// class NavigateToSignupEvent extends LoginEvent {
//   final BuildContext context;
//   const NavigateToSignupEvent({required this.context});
// }

// class NavigateToDashboardEvent extends LoginEvent {
//   final BuildContext context;
//   const NavigateToDashboardEvent({required this.context});
// }

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;

  const LoginSubmitted(this.email, this.password, this.context);

  @override
  List<Object?> get props => [email, password, context];
}

class ResetFormStatus extends LoginEvent {}

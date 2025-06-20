import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEmailChanged extends SignupEvent {
  final String email;
  const RegisterEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class RegisterRoleChanged extends SignupEvent {
  final String role;
  const RegisterRoleChanged(this.role);

  @override
  List<Object?> get props => [role];
}

class RegisterPasswordChanged extends SignupEvent {
  final String password;
  const RegisterPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class RegisterCfmPasswordChanged extends SignupEvent {
  final String cfmPassword;
  const RegisterCfmPasswordChanged(this.cfmPassword);

  @override
  List<Object?> get props => [cfmPassword];
}

class PrivacyPolicyToggled extends SignupEvent {
  final bool value;
  
  const PrivacyPolicyToggled(this.value);

  @override 
  List<Object?> get props => [value];
}

class NavigateToLoginEvent extends SignupEvent {
  final BuildContext context;

  const NavigateToLoginEvent({ required this.context });
}

class TogglePasswordVisibility extends SignupEvent {}

class ToggleConfirmPasswordVisibility extends SignupEvent {}


class EmailSubmitEvent extends SignupEvent {
  final String email;

  const EmailSubmitEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class FullNameAndRoleSubmitEvent extends SignupEvent {
  final String fullName;
  final String role;

  const FullNameAndRoleSubmitEvent(this.fullName, this.role);

  @override
  List<Object?> get props => [fullName, role];
}

class PasswordAndConfirmPasswordSubmitEvent extends SignupEvent {
  final String password;
  final String confirmPassword;

  const PasswordAndConfirmPasswordSubmitEvent(this.password, this.confirmPassword);

  @override
  List<Object?> get props => [password, confirmPassword];
}

class VerifyOtpEvent extends SignupEvent {
  final String otp;
  const VerifyOtpEvent(this.otp);

  @override
  List<Object?> get props => [otp];
}

class ResendOtpEvent extends SignupEvent {}

class OnFormSubmittedEvent extends SignupEvent {
  final String email;
  final String role;
  final String password;

  const OnFormSubmittedEvent(this.email, this.role, this.password);

  @override
  List<Object?> get props => [email, role, password];
}

class FormReset extends SignupEvent {}

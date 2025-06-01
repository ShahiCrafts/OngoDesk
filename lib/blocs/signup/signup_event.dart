import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class RegisterEmailChanged extends SignupEvent {
  final String email;
  const RegisterEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PrivacyPolicyChecked extends SignupEvent {
  final bool value;
  const PrivacyPolicyChecked(this.value);

  @override
  List<Object?> get props => [value];
}

class FormReset extends SignupEvent {}
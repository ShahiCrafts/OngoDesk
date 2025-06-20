import 'package:equatable/equatable.dart';

enum EmailFormStatus {
  initial,
  submitting,
  success,
  failure,
  otpVerified,
  otpFailure,
  nameAndRoleSubmitted
}

class SignupState extends Equatable {
  final String email;
  final String fullName;
  final String role;
  final String password;
  final String? cfmPassword;
  final bool privacyPolicy;
  final EmailFormStatus emailFormStatus;
  final String? message;
  final String? otpCode;
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  const SignupState({
    this.email = '',
    this.fullName = '',
    this.role = '',
    this.password = '',
    this.cfmPassword,
    this.privacyPolicy = false,
    this.emailFormStatus = EmailFormStatus.initial,
    this.message,
    this.otpCode = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
  });

  SignupState copyWith({
    String? email,
    String? fullName,
    String? role,
    String? password,
    String? cfmPassword,
    bool? privacyPolicy,
    EmailFormStatus? emailFormStatus,
    String? message,
    String? otpCode,
    bool? obscurePassword,
    bool? obscureConfirmPassword
  }) {
    return SignupState(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      password: password ?? this.password,
      cfmPassword: cfmPassword ?? this.cfmPassword,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      emailFormStatus: emailFormStatus ?? this.emailFormStatus,
      message: message ?? this.message,
      otpCode: otpCode ?? this.otpCode,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    email,
    fullName,
    role,
    password,
    cfmPassword,
    privacyPolicy,
    emailFormStatus,
    message,
    otpCode,
    obscurePassword,
    obscureConfirmPassword
  ];
}

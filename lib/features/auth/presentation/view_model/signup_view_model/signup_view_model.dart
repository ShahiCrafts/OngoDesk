import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/app/get_it/service_locator.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:ongo_desk/features/auth/presentation/view/login_view.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final AuthRegisterUsecase _authRegisterUsecase;
  final _random = Random.secure();

  SignupViewModel(this._authRegisterUsecase) : super(const SignupState()) {
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterRoleChanged>(_onRoleChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterCfmPasswordChanged>(_onCfmPasswordChanged);
    on<PrivacyPolicyToggled>(_onPrivacyPolicyToggled);
    on<NavigateToLoginEvent>(_onNavigateToLogin);
    on<EmailSubmitEvent>(_onEmailSubmitted);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<FullNameAndRoleSubmitEvent>(_onFullNameAndRoleSubmitted);
    on<FormReset>(_onResetForm);
    on<OnFormSubmittedEvent>(_onFormSubmitted);
    on<TogglePasswordVisibility>(_onTogglePassword);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPassword);
  }

  void _onEmailChanged(RegisterEmailChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onTogglePassword(TogglePasswordVisibility event, Emitter<SignupState> emit) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onToggleConfirmPassword(ToggleConfirmPasswordVisibility event, Emitter<SignupState> emit) {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  void _onRoleChanged(RegisterRoleChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(role: event.role));
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void _onCfmPasswordChanged(
    RegisterCfmPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(cfmPassword: event.cfmPassword));
  }

  void _onPrivacyPolicyToggled(
    PrivacyPolicyToggled event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(privacyPolicy: event.value));
  }

  void _onEmailSubmitted(
    EmailSubmitEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(
      state.copyWith(
        emailFormStatus: EmailFormStatus.submitting,
        message: 'Sending verification code...',
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    final code = (100000 + _random.nextInt(900000)).toString();

    emit(
      state.copyWith(
        email: event.email,
        emailFormStatus: EmailFormStatus.success,
        message: 'Verification code sent successfully! $code',
        otpCode: code,
      ),
    );
  }

  void _onVerifyOtp(VerifyOtpEvent event, Emitter<SignupState> emit) async {
    emit(state.copyWith(emailFormStatus: EmailFormStatus.submitting));

    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency

    if (event.otp == state.otpCode) {
      emit(state.copyWith(
        emailFormStatus: EmailFormStatus.otpVerified,
        message: 'Verification Successful!',
      ));
    } else {
      emit(state.copyWith(
        emailFormStatus: EmailFormStatus.otpFailure,
        message: 'Invalid code. Please try again.',
      ));
    }
  }

  void _onResendOtp(ResendOtpEvent event, Emitter<SignupState> emit) async {
    emit(state.copyWith(message: 'Sending a new code...'));

    await Future.delayed(const Duration(seconds: 2));

    final newCode = (100000 + _random.nextInt(900000)).toString();
    
    emit(state.copyWith(
      otpCode: newCode,
      message: 'A new verification code has been sent.',
    ));
  }

  void _onFullNameAndRoleSubmitted(
    FullNameAndRoleSubmitEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(emailFormStatus: EmailFormStatus.submitting));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(
      fullName: event.fullName,
      role: event.role,
      emailFormStatus: EmailFormStatus.nameAndRoleSubmitted,
      message: 'Details saved successfully!',
    ));
  }

  Future<void> _onFormSubmitted(
    OnFormSubmittedEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(emailFormStatus: EmailFormStatus.submitting));

    final result = await _authRegisterUsecase(
      AuthRegisterParams(
        email: event.email,
        role: event.role,
        password: event.password,
      ),
    );

    // No need for an extra delay here as the usecase has latency.

    result.fold(
      (failure) {
        // *** FIX: Use the specific error message from the failure object ***
        // This will now show you the actual reason for the failure,
        // e.g., "Email already in use" or "Network Error".
        emit(
          state.copyWith(
            emailFormStatus: EmailFormStatus.failure,
            message: failure.message, // Assuming your Failure class has a `message` property
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            emailFormStatus: EmailFormStatus.success,
            message: 'Registration Successful!',
          ),
        );
      },
    );
  }

  void _onNavigateToLogin(
    NavigateToLoginEvent event,
    Emitter<SignupState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: LoginView(),
              ),
        ),
      );
    }
  }

  void _onResetForm(FormReset event, Emitter<SignupState> emit) {
    emit(
      state.copyWith(emailFormStatus: EmailFormStatus.initial, message: null),
    );
  }
}

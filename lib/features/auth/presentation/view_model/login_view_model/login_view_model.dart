import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/core/common/snackbar/my_snackbar.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final AuthLoginUsecase _authLoginUsecase;
  final void Function({
    required BuildContext context,
    required String message,
    Color? color,
  }) _showSnackbar;

  LoginViewModel(
    this._authLoginUsecase, {
    void Function({
      required BuildContext context,
      required String message,
      Color? color,
    })? showSnackbar,
  }) : _showSnackbar = showSnackbar ?? showMySnackBar,
       super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<TogglePasswordVisibility>(_onTogglePassword);
    on<RememberMeToggled>(_onToggleRememberMe);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onTogglePassword(
      TogglePasswordVisibility event, Emitter<LoginState> emit) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onToggleRememberMe(
      RememberMeToggled event, Emitter<LoginState> emit) {
    emit(state.copyWith(rememberMe: event.value));
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(
      formStatus: FormStatus.submitting,
      message: 'Submission Under Process',
    ));

    await Future.delayed(const Duration(seconds: 2));

    final result = await _authLoginUsecase(
      LoginParams(email: state.email, password: state.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          formStatus: FormStatus.failure,
          message: 'Login Failed!',
        ));
        _showSnackbar(
          context: event.context,
          message: 'Invalid Credentials, Please try again.',
        );
      },
      (success) {
        emit(state.copyWith(
          formStatus: FormStatus.success,
          message: 'Login Successful!',
        ));
      },
    );
  }
}

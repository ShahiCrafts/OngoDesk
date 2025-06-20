import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {

  final AuthLoginUsecase _authLoginUsecase;

  LoginViewModel(
    this._authLoginUsecase
  ) : super(LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<TogglePasswordVisibility>(_onTogglePassword);
    on<RememberMeToggled>(_onToggleRememberMe);
    on<ResetFormStatus>(_onResetFormStatus);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = event.email;

    emit(state.copyWith(email: email));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = event.password;

    emit(state.copyWith(password: password));
  }

  void _onTogglePassword(TogglePasswordVisibility event, Emitter<LoginState> emit) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void _onToggleRememberMe(RememberMeToggled event, Emitter<LoginState> emit) {
    final rememberMe = event.value;

    emit(state.copyWith(rememberMe: rememberMe));
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final email = state.email;
    final password = state.password;

    emit(state.copyWith(formStatus: FormStatus.submitting, message: 'Submission Under Process'));

    await Future.delayed(Duration(seconds: 2));

    final result = await _authLoginUsecase(
      LoginParams(email: email, password: password)
    ); 

    result.fold(
      (left)=> {
        emit(state.copyWith(formStatus: FormStatus.failure, message: 'Login Failed!'))
      },

      (right) => {
        emit(state.copyWith(formStatus: FormStatus.success, message: 'Login Successful!'))
      }
    );
  }

  void _onResetFormStatus(ResetFormStatus event, Emitter<LoginState> emit) {
    emit(state.copyWith(formStatus: FormStatus.initial, message: null));
  }
}

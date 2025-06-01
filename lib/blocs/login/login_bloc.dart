import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/blocs/login/login_event.dart';
import 'package:ongo_desk/blocs/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
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

    if (email == 'dev.shahi.apps@gmail.com' && password == 'admin@123') {
      emit(state.copyWith(formStatus: FormStatus.success, message: 'Login Successful'));
    } else {
      emit(state.copyWith(formStatus: FormStatus.failure, message: 'Invalid credentials'));
    }
  }

  void _onResetFormStatus(ResetFormStatus event, Emitter<LoginState> emit) {
    emit(state.copyWith(formStatus: FormStatus.initial, message: null));
  }
}

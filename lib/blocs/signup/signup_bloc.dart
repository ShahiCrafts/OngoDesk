import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/blocs/signup/signup_event.dart';
import 'package:ongo_desk/blocs/signup/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<RegisterEmailChanged>(_onEmailChanged);
    on<PrivacyPolicyChecked>(_onPolicyChecked);
    on<FormReset>(_onResetForm);
  }

  void _onEmailChanged(RegisterEmailChanged event, Emitter<SignupState> emit) {
    final email = event.email;

    emit(state.copyWith(email: email));
  }

  void _onPolicyChecked(PrivacyPolicyChecked event, Emitter<SignupState> emit) {
    final value = event.value;

    emit(state.copyWith(value: value));
  }

  void _onResetForm(FormReset event, Emitter<SignupState> emit) {
    emit(state.copyWith(emailFormStatus: EmailFormStatus.initial, message: null));
  }
}

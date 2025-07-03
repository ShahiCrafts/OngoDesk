import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/core/common/snackbar/my_snackbar.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_otp_usecase.dart';
import 'email_entry_event.dart';
import 'email_entry_state.dart';

class EmailEntryViewModel extends Bloc<EmailEntryEvent, EmailEntryState> {
  final SendOtpUsecase _sendOtpUsecase;
  EmailEntryViewModel(this._sendOtpUsecase) : super(EmailEntryState.initial()) {
    on<PrivacyPolicyToggled>(_onPrivacyPolicyToggled);
    on<EmailSubmitEvent>(_onEmailSubmit);
    on<NavigateToOtpEntryEvent>(_onNavigateToOtpEntryScreen);
  }

  void _onPrivacyPolicyToggled(
    PrivacyPolicyToggled event,
    Emitter<EmailEntryState> emit,
  ) {
    emit(state.copyWith(privacyPolicyAgreed: event.value));
  }

  Future<void> _onEmailSubmit(
    EmailSubmitEvent event,
    Emitter<EmailEntryState> emit,
  ) async {
    emit(state.copyWith(status: EmailFormStatus.submitting));
    final email = event.email.trim();

    final result = await _sendOtpUsecase(email);

    result.fold(
      (failure) {
        emit(state.copyWith(status: EmailFormStatus.failure));

        if (event.context.mounted) {
          showMySnackBar(
            context: event.context,
            message: failure.message,
            color: Colors.red,
          );
        }
      },
      (success) async {
        emit(state.copyWith(email: email, status: EmailFormStatus.success));
        if (event.context.mounted) {
          showMySnackBar(
            context: event.context,
            message: 'A 6-digit code has been sent to your email $email',
          );
          add(NavigateToOtpEntryEvent(context: event.context));
        }
      },
    );
  }

  void _onNavigateToOtpEntryScreen(
    NavigateToOtpEntryEvent event,
    Emitter<EmailEntryState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushNamed(event.context, '/code-entry');
    }
  }
}

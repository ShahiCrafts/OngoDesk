import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_otp_usecase.dart';
import 'otp_entry_event.dart';
import 'otp_entry_state.dart';

class OtpEntryViewModel extends Bloc<OtpEntryEvent, OtpEntryState> {
  final VerifyOtpUsecase _verifyOtpUsecase;
  final SendOtpUsecase _sendOtpUsecase;

  OtpEntryViewModel(this._verifyOtpUsecase, this._sendOtpUsecase)
    : super(const OtpEntryState()) {
    on<OtpDigitChanged>(_onDigitChanged);
    on<SubmitOtpEvent>(_onSubmitOtp);
    on<ResendOtpRequested>(_onResendOtp);
    on<NavigateToDetailEntryEvent>(_onNavigateToDetailEntryScreen);
  }

  void _onDigitChanged(OtpDigitChanged event, Emitter<OtpEntryState> emit) {
    final updatedDigits = List<String>.from(state.otpDigits);
    updatedDigits[event.index] = event.value;

    emit(state.copyWith(otpDigits: updatedDigits));
  }

  Future<void> _onSubmitOtp(
    SubmitOtpEvent event,
    Emitter<OtpEntryState> emit,
  ) async {
    if (state.code.length != 6 || event.email.isEmpty) return;

    emit(state.copyWith(status: OtpFormStatus.submitting));

    final result = await _verifyOtpUsecase(
      VerifyOtpParams(email: event.email, code: event.code),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: OtpFormStatus.failure,
            otpDigits: List.filled(6, ''),
          ),
        );
      },
      (success) {
        emit(state.copyWith(status: OtpFormStatus.success));
        add(NavigateToDetailEntryEvent(context: event.context));
      },
    );
  }

  Future<void> _onResendOtp(
    ResendOtpRequested event,
    Emitter<OtpEntryState> emit,
  ) async {
    if (event.email.isEmpty) return;

    emit(state.copyWith(status: OtpFormStatus.submitting));

    final result = await _sendOtpUsecase(event.email);

    result.fold(
      (failure) => emit(state.copyWith(status: OtpFormStatus.failure)),
      (success) => emit(state.copyWith(status: OtpFormStatus.initial)),
    );
  }

  void _onNavigateToDetailEntryScreen(
    NavigateToDetailEntryEvent event,
    Emitter<OtpEntryState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushNamed(event.context, '/detail-entry');
    }
  }
}

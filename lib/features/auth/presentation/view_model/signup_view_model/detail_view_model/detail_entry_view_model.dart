import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/core/common/snackbar/my_snackbar.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_register_usecase.dart';
import 'detail_entry_event.dart';
import 'detail_entry_state.dart';

class DetailEntryViewModel extends Bloc<DetailEntryEvent, DetailEntryState> {
  final AuthRegisterUsecase _authRegisterUsecase;
  final void Function({
    required BuildContext context,
    required String message,
    Color? color,
  })
  _showSnackbar;

  DetailEntryViewModel(
    this._authRegisterUsecase, {
    void Function({
      required BuildContext context,
      required String message,
      Color? color,
    })?
    showSnackBar,
  }) : _showSnackbar = showSnackBar ?? showMySnackBar,
       super(const DetailEntryState()) {
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });

    on<SubmitDetailEntryForm>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitDetailEntryForm event,
    Emitter<DetailEntryState> emit,
  ) async {
    emit(state.copyWith(status: DetailFormStatus.isSubmitting));

    final result = await _authRegisterUsecase(
      AuthRegisterParams(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: DetailFormStatus.failure));
        _showSnackbar(context: event.context, message: failure.message);
      },
      (success) async {
        emit(state.copyWith(status: DetailFormStatus.success));
        if (event.context.mounted) {
          _showSnackbar(
            context: event.context,
            message: 'Account successfully created!',
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/core/common/snackbar/my_snackbar.dart';
import 'package:ongo_desk/core/network/hive_service.dart';
import 'package:ongo_desk/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_register_usecase.dart';
import 'detail_entry_event.dart';
import 'detail_entry_state.dart';

class DetailEntryViewModel extends Bloc<DetailEntryEvent, DetailEntryState> {
  final AuthRegisterUsecase _authRegisterUsecase;

  DetailEntryViewModel(this._authRegisterUsecase)
    : super(const DetailEntryState()) {
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });

    on<SubmitDetailEntryForm>(_onSubmit);
    on<NavigateBackToLogin>(_onNavigateBackToLogin);
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
        showMySnackBar(context: event.context, message: failure.message);
      },
      (success) async {
        emit(state.copyWith(status: DetailFormStatus.success));
        // In your registration BLoC, after a successful registration:
        final localDataSource = AuthLocalDataSource(hiveService: HiveService());
        await localDataSource.runHashIntegrityTest(
          event.email, // email from the form
          state.password, // password from the form
        );
        showMySnackBar(
          context: event.context,
          message: 'Account successfully created!',
        );
        add(NavigateBackToLogin(context: event.context));
      },
    );
  }

  void _onNavigateBackToLogin(
    NavigateBackToLogin event,
    Emitter<DetailEntryState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacementNamed(event.context, '/login');
    }
  }
}

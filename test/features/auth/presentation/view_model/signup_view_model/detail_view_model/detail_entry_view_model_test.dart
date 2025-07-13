import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ongo_desk/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_state.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_view_model.dart';

// Mock AuthRegisterUsecase
class MockAuthRegisterUsecase extends Mock implements AuthRegisterUsecase {}

// Mock BuildContext with mounted implemented
class MockBuildContext extends Mock implements BuildContext {
  @override
  bool get mounted => true;
}

void main() {
  late MockAuthRegisterUsecase mockAuthRegisterUsecase;
  late List<String> snackbarMessages;

  const fullName = 'Test User';
  const email = 'test@example.com';
  const password = 'password123';

  // Snackbar interceptor for tests
  void testSnackbar({
    required BuildContext context,
    required String message,
    Color? color,
  }) {
    snackbarMessages.add(message);
  }

  setUpAll(() {
    registerFallbackValue(
      AuthRegisterParams(fullName: fullName, email: email, password: password),
    );
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockAuthRegisterUsecase = MockAuthRegisterUsecase();
    snackbarMessages = [];
  });

  group('DetailEntryViewModel Tests', () {
    test('Initial state is DetailEntryState()', () {
      final vm = DetailEntryViewModel(mockAuthRegisterUsecase);
      expect(vm.state, const DetailEntryState());
    });

    blocTest<DetailEntryViewModel, DetailEntryState>(
      'toggles obscurePassword when TogglePasswordVisibility is triggered',
      build: () => DetailEntryViewModel(mockAuthRegisterUsecase),
      seed: () => const DetailEntryState(obscurePassword: true),
      act: (bloc) => bloc.add(TogglePasswordVisibility()),
      expect: () => [const DetailEntryState(obscurePassword: false)],
    );

    blocTest<DetailEntryViewModel, DetailEntryState>(
      'emits [submitting, success] and shows success snackbar on SubmitDetailEntryForm success',
      build: () {
        when(() => mockAuthRegisterUsecase(any()))
            .thenAnswer((_) async => const Right(null));
        return DetailEntryViewModel(
          mockAuthRegisterUsecase,
          showSnackBar: testSnackbar,
        );
      },
      act: (bloc) {
        bloc.add(
          SubmitDetailEntryForm(
            context: MockBuildContext(),
            fullName: fullName,
            email: email,
            password: password,
          ),
        );
      },
      expect: () => [
        const DetailEntryState(status: DetailFormStatus.isSubmitting),
        const DetailEntryState(status: DetailFormStatus.success),
      ],
      verify: (_) {
        verify(() => mockAuthRegisterUsecase.call(any())).called(1);
        expect(snackbarMessages, contains('Account successfully created!'));
      },
    );

    blocTest<DetailEntryViewModel, DetailEntryState>(
      'emits [submitting, failure] and shows error snackbar on SubmitDetailEntryForm failure',
      build: () {
        when(() => mockAuthRegisterUsecase(any())).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Email already exists')),
        );
        return DetailEntryViewModel(
          mockAuthRegisterUsecase,
          showSnackBar: testSnackbar,
        );
      },
      act: (bloc) {
        bloc.add(
          SubmitDetailEntryForm(
            context: MockBuildContext(),
            fullName: fullName,
            email: email,
            password: password,
          ),
        );
      },
      expect: () => [
        const DetailEntryState(status: DetailFormStatus.isSubmitting),
        const DetailEntryState(status: DetailFormStatus.failure),
      ],
      verify: (_) {
        verify(() => mockAuthRegisterUsecase.call(any())).called(1);
        expect(snackbarMessages, contains('Email already exists'));
      },
    );
  });
}

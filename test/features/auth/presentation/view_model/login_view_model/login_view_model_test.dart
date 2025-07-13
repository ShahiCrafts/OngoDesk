import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class MockAuthLoginUsecase extends Mock implements AuthLoginUsecase {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockAuthLoginUsecase mockAuthLoginUsecase;
  late List<String> snackbarMessages;

  const email = 'test@example.com';
  const password = 'password123';

  void testSnackBar({
    required BuildContext context,
    required String message,
    Color? color,
  }) {
    snackbarMessages.add(message);
  }

  setUpAll(() {
    registerFallbackValue(LoginParams(email: email, password: password));
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockAuthLoginUsecase = MockAuthLoginUsecase();
    snackbarMessages = [];
  });

  group('LoginViewModel - Full Coverage (excluding ResetFormStatus)', () {
    test('Initial state is correct', () {
      final vm = LoginViewModel(mockAuthLoginUsecase);
      expect(vm.state, const LoginState());
    });

    blocTest<LoginViewModel, LoginState>(
      'emits updated email on LoginEmailChanged',
      build: () => LoginViewModel(mockAuthLoginUsecase),
      act: (bloc) => bloc.add(const LoginEmailChanged(email)),
      expect: () => [const LoginState(email: email)],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits updated password on LoginPasswordChanged',
      build: () => LoginViewModel(mockAuthLoginUsecase),
      act: (bloc) => bloc.add(const LoginPasswordChanged(password)),
      expect: () => [const LoginState(password: password)],
    );

    blocTest<LoginViewModel, LoginState>(
      'toggles obscurePassword value',
      build: () => LoginViewModel(mockAuthLoginUsecase),
      seed: () => const LoginState(obscurePassword: true),
      act: (bloc) => bloc.add(TogglePasswordVisibility()),
      expect: () => [const LoginState(obscurePassword: false)],
    );

    blocTest<LoginViewModel, LoginState>(
      'updates rememberMe on RememberMeToggled',
      build: () => LoginViewModel(mockAuthLoginUsecase),
      act: (bloc) => bloc.add(RememberMeToggled(true)),
      expect: () => [const LoginState(rememberMe: true)],
    );

    blocTest<LoginViewModel, LoginState>(
      'LoginSubmitted success: emits [submitting, success]',
      build: () {
        when(() => mockAuthLoginUsecase(any()))
            .thenAnswer((_) async => const Right('Success'));
        return LoginViewModel(mockAuthLoginUsecase, showSnackbar: testSnackBar);
      },
      act: (bloc) {
        bloc.add(const LoginEmailChanged(email));
        bloc.add(const LoginPasswordChanged(password));
        bloc.add(LoginSubmitted(email, password, FakeBuildContext()));
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        const LoginState(email: email),
        const LoginState(email: email, password: password),
        const LoginState(
          email: email,
          password: password,
          formStatus: FormStatus.submitting,
          message: 'Submission Under Process',
        ),
        const LoginState(
          email: email,
          password: password,
          formStatus: FormStatus.success,
          message: 'Login Successful!',
        ),
      ],
      verify: (_) {
        verify(() => mockAuthLoginUsecase.call(any())).called(1);
        expect(snackbarMessages, isEmpty);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'LoginSubmitted failure: emits [submitting, failure] and triggers snackbar',
      build: () {
        when(() => mockAuthLoginUsecase(any()))
            .thenAnswer((_) async => Left(ApiFailure(message: 'Invalid')));
        return LoginViewModel(mockAuthLoginUsecase, showSnackbar: testSnackBar);
      },
      act: (bloc) {
        bloc.add(const LoginEmailChanged(email));
        bloc.add(const LoginPasswordChanged(password));
        bloc.add(LoginSubmitted(email, password, FakeBuildContext()));
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        const LoginState(email: email),
        const LoginState(email: email, password: password),
        const LoginState(
          email: email,
          password: password,
          formStatus: FormStatus.submitting,
          message: 'Submission Under Process',
        ),
        const LoginState(
          email: email,
          password: password,
          formStatus: FormStatus.failure,
          message: 'Login Failed!',
        ),
      ],
      verify: (_) {
        verify(() => mockAuthLoginUsecase.call(any())).called(1);
        expect(snackbarMessages, contains('Invalid Credentials, Please try again.'));
      },
    );
  });
}

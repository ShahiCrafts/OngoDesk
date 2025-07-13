import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:ongo_desk/features/auth/domain/repository/auth_repository.dart';
import 'package:ongo_desk/core/network/auth_service.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockAuthService extends Mock implements AuthService {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockAuthRepository repository;
  late MockAuthService authService;
  late AuthLoginUsecase usecase;

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    repository = MockAuthRepository();
    authService = MockAuthService();
    usecase = AuthLoginUsecase(
      authRepository: repository,
      authService: authService,
    );
  });

  group('AuthLoginUsecase', () {
    test(
      "should call loginToAccount with correct email/password and sign in with token",
      () async {
        const email = 'saugat@example.com';
        const password = 'saugatshahi';
        const token = 'mocked_token';
        final user = FakeUserEntity();

        when(() => repository.loginToAccount(email, password))
            .thenAnswer((_) async => Right((token: token, user: user)));

        when(() => authService.signIn(user, token))
            .thenAnswer((_) async {});

        final result = await usecase(
          LoginParams(email: email, password: password),
        );

        expect(result, const Right(token));
        verify(() => repository.loginToAccount(email, password)).called(1);
        verify(() => authService.signIn(user, token)).called(1);
        verifyNoMoreInteractions(repository);
        verifyNoMoreInteractions(authService);
      },
    );

    test(
      "should return failure if login fails and not call authService",
      () async {
        const email = 'shahi.saugat@gmail.com';
        const password = 'wrongpass';
        const failure = ApiFailure(message: 'Invalid credentials');

        when(() => repository.loginToAccount(email, password))
            .thenAnswer((_) async => const Left(failure));

        final result = await usecase(
          LoginParams(email: email, password: password),
        );

        expect(result, const Left(failure));
        verify(() => repository.loginToAccount(email, password)).called(1);
        verifyNever(() => authService.signIn(any(), any()));
        verifyNoMoreInteractions(repository);
        verifyNoMoreInteractions(authService);
      },
    );

    test('AuthLoginUsecase constructor initializes fields', () {
      final repo = MockAuthRepository();
      final service = MockAuthService();

      final instance = AuthLoginUsecase(authRepository: repo, authService: service);

      expect(instance, isA<AuthLoginUsecase>());
    });
  });

  group('LoginParams', () {
    test('LoginParams.initial() creates empty parameters', () {
      final params = LoginParams.initial();
      expect(params.email, '');
      expect(params.password, '');
    });

    test('LoginParams props returns correct values', () {
      final params = LoginParams(email: 'a', password: 'b');
      expect(params.props, ['a', 'b']);
    });

    test('LoginParams props getter is accessed', () {
      final params = LoginParams(email: 'x', password: 'y');
      final props = params.props;
      expect(props, isNotNull);
    });
  });

  tearDown(() {
    reset(repository);
    reset(authService);
  });
}

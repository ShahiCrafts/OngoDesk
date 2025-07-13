import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:ongo_desk/features/auth/domain/repository/auth_repository.dart';
import 'package:ongo_desk/core/error/failure.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_register_usecase.dart';

// Mock and Fake classes
class MockAuthRepository extends Mock implements IAuthRepository {}
class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  // Register fallback for UserEntity to allow use of `any()`
  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  late MockAuthRepository repository;
  late AuthRegisterUsecase usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = AuthRegisterUsecase(authRepository: repository);
  });

  group('AuthRegisterUsecase', () {
    final params = AuthRegisterParams(
      fullName: 'Test User',
      email: 'test@example.com',
      password: 'password123',
    );

    test('should call createAccount with UserEntity and return success', () async {
      when(() => repository.createAccount(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase.call(params);

      expect(result, const Right(null));
      verify(() => repository.createAccount(
        UserEntity(
          fullName: params.fullName,
          email: params.email,
          password: params.password,
        ),
      )).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should call createAccount and return failure', () async {
      const failure = ApiFailure(message: 'Failed to create account');
      when(() => repository.createAccount(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase.call(params);

      expect(result, const Left(failure));
      verify(() => repository.createAccount(any())).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('AuthRegisterUsecase constructor initializes correctly', () {
      final instance = AuthRegisterUsecase(authRepository: repository);
      expect(instance, isA<AuthRegisterUsecase>());
    });
  });

  group('AuthRegisterParams', () {
    test('initial constructor initializes fields', () {
      final params = AuthRegisterParams.initial(
        fullName: '',
        email: '',
        password: '',
      );
      expect(params.fullName, '');
      expect(params.email, '');
      expect(params.password, '');
    });

    test('props returns correct list of fields', () {
      final params = AuthRegisterParams(
        fullName: 'John Doe',
        email: 'john@example.com',
        password: 'secret',
      );
      expect(params.props, ['John Doe', 'john@example.com', 'secret']);
    });

    test('props getter can be accessed', () {
      final params = AuthRegisterParams(
        fullName: 'Saugat',
        email: 'shahi@example.com',
        password: 'pass',
      );
      final props = params.props;
      expect(props, isNotNull);
    });
  });
}

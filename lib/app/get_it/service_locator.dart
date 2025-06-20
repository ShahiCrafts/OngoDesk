import 'package:get_it/get_it.dart';
import 'package:ongo_desk/core/network/hive_service.dart';
import 'package:ongo_desk/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:ongo_desk/features/auth/data/repository/auth_local_repository.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:ongo_desk/features/auth/presentation/auth/view_model/login_view_model/login_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/auth/view_model/signup_view_model/signup_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuthModule();
  _initHiveService();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initAuthModule() async {
  serviceLocator.registerFactory(
    () => AuthLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => AuthLocalRepository(
      authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => AuthRegisterUsecase(authRepository: serviceLocator<AuthLocalRepository>())
  );

   serviceLocator.registerFactory(
    () => AuthLoginUsecase(authRepository: serviceLocator<AuthLocalRepository>())
  );

  serviceLocator.registerFactory<LoginViewModel>(() => LoginViewModel(
    serviceLocator<AuthLoginUsecase>()
  ));

  serviceLocator.registerLazySingleton<SignupViewModel>(() => SignupViewModel(
    serviceLocator<AuthRegisterUsecase>()
  ));
}

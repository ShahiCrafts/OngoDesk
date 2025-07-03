import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ongo_desk/core/common/internet_check/internet_checker_impl.dart';
import 'package:ongo_desk/core/network/api_service.dart';
import 'package:ongo_desk/core/network/hive_service.dart';
import 'package:ongo_desk/core/network/token_storage_service.dart';
import 'package:ongo_desk/core/utils/internet_checker.dart';
import 'package:ongo_desk/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:ongo_desk/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:ongo_desk/features/auth/data/repository/auth_local_repository.dart';
import 'package:ongo_desk/features/auth/data/repository/auth_remote_repository.dart';
import 'package:ongo_desk/features/auth/domain/repository/auth_repository.dart';
import 'package:ongo_desk/features/auth/domain/repository/auth_repository_impl.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_otp_usecase.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/email_view_model/email_entry_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/otp_view_model/otp_entry_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize all modules
  await _initHiveService();
  await _initSharedPrefs();

  _initApiService();
  _initAuthModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

void _initApiService() {
  final tokenService = serviceLocator<TokenStorageService>();
  serviceLocator.registerLazySingleton<ApiService>(
    () => ApiService(Dio(), tokenService),
  );
}

Future<void> _initSharedPrefs() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  serviceLocator.registerLazySingleton<TokenStorageService>(
    () => TokenStorageService(),
  );
}

void _initAuthModule() {
  // Utilities
  serviceLocator.registerLazySingleton<InternetChecker>(
    () => InternetCheckerImpl(),
  );
  // Data sources (local and remote)
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories (local and remote)
  serviceLocator.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepository(
      authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
    ),
  );

  serviceLocator.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(
      authRemoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );

  // Main repository implementing IAuthRepository with online/offline logic
  serviceLocator.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteRepository: serviceLocator<AuthRemoteRepository>(),
      localRepository: serviceLocator<AuthLocalRepository>(),
      internetChecker: serviceLocator<InternetChecker>(),
    ),
  );

  // Use cases (inject the main repository interface)
  serviceLocator.registerFactory(
    () =>
        AuthRegisterUsecase(authRepository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory(
    () => SendOtpUsecase(authRepository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory(
    () => VerifyOtpUsecase(authRepository: serviceLocator<IAuthRepository>()),
  );

  serviceLocator.registerFactory(
    () => AuthLoginUsecase(
      authRepository: serviceLocator<IAuthRepository>(),
      tokenStorageService: serviceLocator<TokenStorageService>(),
    ),
  );

  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<AuthLoginUsecase>()),
  );

  serviceLocator.registerLazySingleton<EmailEntryViewModel>(
    () => EmailEntryViewModel(serviceLocator<SendOtpUsecase>()),
  );

  serviceLocator.registerLazySingleton<OtpEntryViewModel>(
    () => OtpEntryViewModel(
      serviceLocator<VerifyOtpUsecase>(),
      serviceLocator<SendOtpUsecase>(),
    ),
  );

  serviceLocator.registerLazySingleton<DetailEntryViewModel>(
    () => DetailEntryViewModel(serviceLocator<AuthRegisterUsecase>()),
  );
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ongo_desk/core/common/internet_check/internet_checker_impl.dart';
import 'package:ongo_desk/core/network/api_service.dart';
import 'package:ongo_desk/core/network/auth_service.dart';
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
import 'package:ongo_desk/features/create_post/data/data_source/remote_data_source/category_remote_data_source.dart';
import 'package:ongo_desk/features/create_post/data/data_source/remote_data_source/post_remote_data_source.dart';
import 'package:ongo_desk/features/create_post/data/data_source/remote_data_source/tag_remote_data_source.dart';
import 'package:ongo_desk/features/create_post/data/repository/category_remote_repository.dart';
import 'package:ongo_desk/features/create_post/data/repository/post_remote_repository.dart';
import 'package:ongo_desk/features/create_post/data/repository/tag_remote_repository.dart';
import 'package:ongo_desk/features/create_post/domain/repository/category_repository.dart';
import 'package:ongo_desk/features/create_post/domain/repository/category_repository_impl.dart';
import 'package:ongo_desk/features/create_post/domain/repository/post_repository.dart';
import 'package:ongo_desk/features/create_post/domain/repository/post_repository_impl.dart';
import 'package:ongo_desk/features/create_post/domain/repository/tag_repository.dart';
import 'package:ongo_desk/features/create_post/domain/repository/tag_repository_impl.dart';
import 'package:ongo_desk/features/create_post/domain/use_case/category_fetch_usecase.dart';
import 'package:ongo_desk/features/create_post/domain/use_case/create_post_usecase.dart';
import 'package:ongo_desk/features/create_post/domain/use_case/tag_fetch_usecase.dart';
import 'package:ongo_desk/features/create_post/presentation/view_model/create_post_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // --- Core / Shared Dependencies ---
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  serviceLocator.registerLazySingleton<TokenStorageService>(
    () => TokenStorageService(),
  );
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
  serviceLocator.registerLazySingleton<InternetChecker>(
    () => InternetCheckerImpl(),
  );

  // ApiService depends on TokenStorageService
  serviceLocator.registerLazySingleton<ApiService>(
    () => ApiService(Dio(), serviceLocator<AuthService>()),
  );

  serviceLocator.registerLazySingleton<AuthService>(() => AuthService());

  // --- Feature Dependencies ---
  _initAuth();
  _initCreatePost();
}

// --- Auth Feature ---
void _initAuth() {
  // Data Sources
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
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
  serviceLocator.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteRepository: serviceLocator<AuthRemoteRepository>(),
      localRepository: serviceLocator<AuthLocalRepository>(),
      internetChecker: serviceLocator<InternetChecker>(),
    ),
  );

  // Use Cases
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
      authService: serviceLocator<AuthService>(),
    ),
  );
  serviceLocator.registerFactory(
    () => CreatePostUsecase(repository: serviceLocator<IPostRepository>()),
  );

  // ViewModels / BLoCs
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

// --- Create Post Feature ---
void _initCreatePost() {
  // Data Sources
  serviceLocator.registerLazySingleton<TagRemoteDataSource>(
    () => TagRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<TagRemoteRepository>(
    () => TagRemoteRepository(
      tagRemoteDataSource: serviceLocator<TagRemoteDataSource>(),
    ),
  );
  serviceLocator.registerLazySingleton<CategoryRemoteRepository>(
    () => CategoryRemoteRepository(
      categoryRemoteDataSource: serviceLocator<CategoryRemoteDataSource>(),
    ),
  );
  serviceLocator.registerLazySingleton<ITagRepository>(
    () => TagRepositoryImpl(
      remoteRepository: serviceLocator<TagRemoteRepository>(),
      internetChecker: serviceLocator<InternetChecker>(),
    ),
  );
  serviceLocator.registerLazySingleton<ICategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteRepository: serviceLocator<CategoryRemoteRepository>(),
      internetChecker: serviceLocator<InternetChecker>(),
    ),
  );

  serviceLocator.registerLazySingleton<PostRemoteRepository>(
    () => PostRemoteRepository(
      remoteDataSource: serviceLocator<PostRemoteDataSource>(),
    ),
  );
  serviceLocator.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(
      remoteRepository: serviceLocator<PostRemoteRepository>(),
      internetChecker: serviceLocator<InternetChecker>(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    // Use factory for use cases if they are lightweight
    () => TagFetchUseCase(tagRepository: serviceLocator<ITagRepository>()),
  );

  serviceLocator.registerFactory(
    // Use factory for use cases if they are lightweight
    () => CategoryFetchUseCase(categoryRepository: serviceLocator<ICategoryRepository>()),
  );

  // ViewModels / BLoCs
  serviceLocator.registerFactory<CreatePostViewModel>(
    // Use factory for BLoCs tied to a screen
    () => CreatePostViewModel(
      tagFetchUseCase: serviceLocator<TagFetchUseCase>(),
      createPostUsecase: serviceLocator<CreatePostUsecase>(),
      categoryFetchUseCase: serviceLocator<CategoryFetchUseCase>()
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/app/get_it/service_locator.dart';
import 'package:ongo_desk/core/network/token_storage_service.dart';
import 'package:ongo_desk/features/auth/presentation/view/signup_view/email_entry_view.dart';
import 'package:ongo_desk/features/auth/presentation/view/login_view.dart';
import 'package:ongo_desk/features/auth/presentation/view/signup_view/detail_entry_view.dart';
import 'package:ongo_desk/features/auth/presentation/view/signup_view/verification_code_view.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/email_view_model/email_entry_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/otp_view_model/otp_entry_view_model.dart';
import 'package:ongo_desk/features/splash/presentation/view/splash_view.dart';
import 'package:ongo_desk/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:ongo_desk/features/dashboard/presentation/view/dashboard_view.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (_) =>
                        SplashViewModel(serviceLocator<TokenStorageService>()),
                child: const SplashView(),
              ),
        );

      case '/login':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: LoginView(),
              ),
        );

      case '/signup':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: serviceLocator<EmailEntryViewModel>(),
                child: EmailEntryView(),
              ),
        );

      case '/code-entry':
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<OtpEntryViewModel>.value(
                    value: serviceLocator<OtpEntryViewModel>(),
                  ),
                  BlocProvider<EmailEntryViewModel>.value(
                    value: serviceLocator<EmailEntryViewModel>(),
                  ),
                ],
                child: const VerificationCodeView(),
              ),
        );

      case '/detail-entry':
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<DetailEntryViewModel>.value(
                    value: serviceLocator<DetailEntryViewModel>(),
                  ),
                  BlocProvider<EmailEntryViewModel>.value(
                    value: serviceLocator<EmailEntryViewModel>(),
                  ),
                ],
                child: DetailEntryView(),
              ),
        );

      case '/dashboard':
        return MaterialPageRoute(builder: (_) => DashboardView());

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page not found!'))),
        );
    }
  }
}

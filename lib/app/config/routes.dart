import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/app/get_it/service_locator.dart';
import 'package:ongo_desk/features/auth/presentation/view/details_entry_view.dart';
import 'package:ongo_desk/features/auth/presentation/view/email_entry_view.dart';
import 'package:ongo_desk/features/auth/presentation/view/login_view.dart';
import 'package:ongo_desk/features/auth/presentation/view/password_entry_view.dart';
import 'package:ongo_desk/features/auth/presentation/view/verification_code_view.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:ongo_desk/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:ongo_desk/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());

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
                value: serviceLocator<SignupViewModel>(),
                child: EmailEntryView(),
              ),
        );

      case '/verify-code':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: serviceLocator<SignupViewModel>(),
                child: VerificationCodeView(),
              ),
        );

      case '/role':
        return MaterialPageRoute(builder: (_) => BlocProvider.value(
                value: serviceLocator<SignupViewModel>(),
                child: DetailsEntryView(),
              ),);

      case '/password-entry':
        return MaterialPageRoute(builder: (_) => BlocProvider.value(
                value: serviceLocator<SignupViewModel>(),
                child: PasswordEntryView(),
              ),);

      case '/dashboard':
        return MaterialPageRoute(builder: (_) => DashboardScreen());

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page not found!'))),
        );
    }
  }
}

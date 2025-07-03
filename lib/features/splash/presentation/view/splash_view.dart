import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/features/splash/presentation/view_model/splash_event.dart';
import 'package:ongo_desk/features/splash/presentation/view_model/splash_state.dart';
import 'package:ongo_desk/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/custom_logo.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => 
      context.read<SplashViewModel>().add(AppStarted(context: context))
    );
    return Scaffold(
      body: BlocBuilder<SplashViewModel, SplashState>(
        builder: (context, state) {
          return Center(child: CustomLogo());
        },
      ),
    );
  }
}

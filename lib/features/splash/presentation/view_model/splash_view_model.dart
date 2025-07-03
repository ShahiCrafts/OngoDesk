import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/core/network/token_storage_service.dart';
import 'package:ongo_desk/features/splash/presentation/view_model/splash_event.dart';
import 'package:ongo_desk/features/splash/presentation/view_model/splash_state.dart';

class SplashViewModel extends Bloc<SplashEvent, SplashState> {
  final TokenStorageService _tokenStorageService;
  SplashViewModel(this._tokenStorageService) : super(SplashState()) {
    on<AppStarted>(_onAppStarted);
    on<NavigateToDashboardEvent>(_onNavigateToDashboard);
    on<NavigateToLoginEvent>(_onNavigateToLogin);
  }

  void _onAppStarted(AppStarted event, Emitter<SplashState> emit) async {
    final token = await _tokenStorageService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      emit(Authenticated());
      if (event.context.mounted) {
        add(NavigateToDashboardEvent(context: event.context));
      }
    } else {
      emit(UnAuthenticated());
      if (event.context.mounted) {
        add(NavigateToLoginEvent(context: event.context));
      }
    }
  }

  void _onNavigateToDashboard(
    NavigateToDashboardEvent event,
    Emitter<SplashState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacementNamed(event.context, '/dashboard');
    }
  }

  void _onNavigateToLogin(
    NavigateToLoginEvent event,
    Emitter<SplashState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacementNamed(event.context, '/login');
    }
  }
}

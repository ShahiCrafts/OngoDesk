import 'package:flutter/material.dart';

@immutable
sealed class SplashEvent {}
class AppStarted extends SplashEvent {
  final BuildContext context;

  AppStarted({ required this.context });
}

class NavigateToDashboardEvent extends SplashEvent {
  final BuildContext context;

  NavigateToDashboardEvent({ required this.context });
}

class NavigateToLoginEvent extends SplashEvent {
  final BuildContext context;

  NavigateToLoginEvent({ required this.context });
}
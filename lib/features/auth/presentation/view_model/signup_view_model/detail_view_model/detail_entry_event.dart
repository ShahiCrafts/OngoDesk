import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DetailEntryEvent extends Equatable {
  const DetailEntryEvent();

  @override
  List<Object?> get props => [];
}

class TogglePasswordVisibility extends DetailEntryEvent {}

class NavigateBackToLogin extends DetailEntryEvent {
  final BuildContext context;

  const NavigateBackToLogin({ required this.context });
}

class SubmitDetailEntryForm extends DetailEntryEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String password;

  const SubmitDetailEntryForm({
    required this.context,
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [context, fullName, email, password];
}

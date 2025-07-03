import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class OtpEntryEvent extends Equatable {
  const OtpEntryEvent();

  @override
  List<Object?> get props => [];
}

class OtpDigitChanged extends OtpEntryEvent {
  final int index;
  final String value;

  const OtpDigitChanged(this.index, this.value);

  @override
  List<Object?> get props => [index, value];
}

class SubmitOtpEvent extends OtpEntryEvent {
  final String email;
  final String code;
  final BuildContext context;

  const SubmitOtpEvent(this.email, this.code, this.context);

  @override
  List<Object?> get props => [context];
}

class ResendOtpRequested extends OtpEntryEvent {
  final String email;
  const ResendOtpRequested(this.email);
}

class NavigateToDetailEntryEvent extends OtpEntryEvent {
  final BuildContext context;
  const NavigateToDetailEntryEvent({ required this.context });
}

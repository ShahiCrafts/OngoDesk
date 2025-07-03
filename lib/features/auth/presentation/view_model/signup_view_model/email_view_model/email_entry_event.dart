import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class EmailEntryEvent extends Equatable {
  const EmailEntryEvent();

  @override
  List<Object?> get props => [];
}

class PrivacyPolicyToggled extends EmailEntryEvent {
  final bool value;

  const PrivacyPolicyToggled(this.value);

  @override
  List<Object?> get props => [value];
}

class EmailSubmitEvent extends EmailEntryEvent {
  final String email;
  final BuildContext context;

  const EmailSubmitEvent(this.email, this.context);

  @override
  List<Object?> get props => [email];
}

class NavigateToOtpEntryEvent extends EmailEntryEvent {
  final BuildContext context;

  const NavigateToOtpEntryEvent({required this.context});
}

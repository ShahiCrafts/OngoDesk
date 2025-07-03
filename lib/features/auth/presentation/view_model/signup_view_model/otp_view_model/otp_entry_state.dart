import 'package:equatable/equatable.dart';

enum OtpFormStatus { initial, submitting, success, failure }

class OtpEntryState extends Equatable {
  final List<String> otpDigits;
  final String email;
  final OtpFormStatus status;

  const OtpEntryState({
    this.otpDigits = const ['', '', '', '', '', ''],
    this.email = '',
    this.status = OtpFormStatus.initial,
  });

  String get code => otpDigits.join();

  OtpEntryState copyWith({
    List<String>? otpDigits,
    String? email,
    OtpFormStatus? status,
  }) {
    return OtpEntryState(
      otpDigits: otpDigits ?? this.otpDigits,
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [otpDigits, email, status];
}

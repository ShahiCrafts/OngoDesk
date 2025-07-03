import 'package:equatable/equatable.dart';

enum DetailFormStatus {
  initial, isSubmitting, success, failure
}

class DetailEntryState extends Equatable {
  final String fullName;
  final String password;
  final bool obscurePassword;
  final DetailFormStatus status;

  const DetailEntryState({
    this.fullName = '',
    this.password = '',
    this.obscurePassword = true,
    this.status = DetailFormStatus.initial,
  });

  factory DetailEntryState.initial() {
    return DetailEntryState(
      fullName: '',
      password: '',
      obscurePassword: true,
      status: DetailFormStatus.initial,
    );
  }

  DetailEntryState copyWith({
    String? fullName,
    String? password,
    bool? obscurePassword,
    DetailFormStatus? status
  }) {
    return DetailEntryState(
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [fullName, password, obscurePassword, status];
}

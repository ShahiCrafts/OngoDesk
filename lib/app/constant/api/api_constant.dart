class ApiConstant {
  ApiConstant._();

  static const connectionTimeoutDuration = Duration(seconds: 1000);
  static const recieveTimeoutDuration = Duration(seconds: 1000);

  static const String serverUri = 'http://10.0.2.2:8080';

  static const String baseUrl = '$serverUri/api/';

  static const String login = 'auth/login';

  static const String sendOtpCode = 'auth/send-verification-code';
  static const String verifyOtpCode = 'auth/verify-code';
  static const String register = 'auth/register';
}

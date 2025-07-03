import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ongo_desk/core/utils/internet_checker.dart';

class InternetCheckerImpl implements InternetChecker {
  @override
  Future<bool> isConnected() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
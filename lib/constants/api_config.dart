import 'package:store_checker/store_checker.dart';

class ApiConfig {
  static const String _devBaseUrl =
      "https://collabflow-api-dev-c32ae278ebe5.herokuapp.com"; // "http://192.168.68.100:5066";

  static const String _prodBaseUrl =
      "https://collabflow-api-prod-315d413dccce.herokuapp.com";

  static Future<String> get baseUrl async {
    final bool isProdMode = await _isProdMode();

    if (!isProdMode) {
      return Future.value(_devBaseUrl);
    }
    return Future.value(_prodBaseUrl);
  }

  static Future<bool> _isProdMode() async{
    var installationSource = await StoreChecker.getSource;
    return installationSource == Source.IS_INSTALLED_FROM_APP_STORE || installationSource == Source.IS_INSTALLED_FROM_PLAY_STORE;
  }
}

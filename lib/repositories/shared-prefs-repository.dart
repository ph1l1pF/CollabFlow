import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsRepository {

    var key = 'onboardingFinished';

  getOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  setOnboardingDone(bool done) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, done);
  }
}
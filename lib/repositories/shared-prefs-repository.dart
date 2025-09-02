import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsRepository {

    var keyOnboardingFinished = 'onboardingFinished';
    var keyFirstCollaborationAlreadyCreated = 'firstCollaboration';

  getOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyOnboardingFinished) ?? false;
  }

  setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyOnboardingFinished, true);
  }

  isFirstCollaboration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyFirstCollaborationAlreadyCreated) ?? true;
  }

  setIsFirstCollaboration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyFirstCollaborationAlreadyCreated, false);
  }
}
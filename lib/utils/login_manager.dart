
//user login
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginManager {
  static const String _loggedInKey = 'isLoggedIn';
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }
}

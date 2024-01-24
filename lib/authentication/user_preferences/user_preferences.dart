import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPreferences {
  static Future<void> storeUserInfo(dynamic user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(user);
    await preferences.setString('currentUserId', userJsonData);
  }

  static Future<Map<String, dynamic>?> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString('currentUserId');

    if (userInfo != null) {
      try {
        Map<String, dynamic> userDataMap = jsonDecode(userInfo);
        return userDataMap;
      } catch (e) {
        print("Error decoding JSON: $e");
        return null;
      }
    }

    return null;
  }
}
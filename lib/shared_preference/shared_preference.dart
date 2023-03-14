import 'package:shared_preferences/shared_preferences.dart';

const String userKey = 'user_data';
const String downloadList = 'download_list';

getPrefStringValue(key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

setPrefStringValue(key,value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

removePrefValue(key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}


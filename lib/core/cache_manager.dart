import 'package:shared_preferences/shared_preferences.dart';

final class CacheManager {
  CacheManager._();
  static final CacheManager db = CacheManager._();
  static SharedPreferences? _database;

  init() async {
    if (_database is! SharedPreferences) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      _database = pref;
    }
  }

  getToken() {
    String token = _database!.getString('token') ?? "";
    return token;
  }

  setToken(String token) async {
    await _database!.setString("token", token);
  }

  deleteToken() async {
    await _database!.clear();
  }
}

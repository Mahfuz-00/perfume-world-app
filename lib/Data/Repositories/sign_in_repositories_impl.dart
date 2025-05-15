import '../../Domain/Repositories/sign_in_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninRepositoryImpl implements SigninRepository {
  static const _tokenKey = '';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    String? Token = prefs.getString(_tokenKey);
    print("The saved token is: $Token");
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? Token = prefs.getString(_tokenKey);
    return Token;
  }

  @override
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  @override
  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }
}

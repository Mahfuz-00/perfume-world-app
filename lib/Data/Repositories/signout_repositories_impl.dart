import 'package:shared_preferences/shared_preferences.dart';

import '../../Domain/Repositories/signout_repositories.dart';

class SignOutRepositoryImpl implements SignOutRepository {
  static const _tokenKey = '';

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

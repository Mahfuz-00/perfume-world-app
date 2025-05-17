import 'package:shared_preferences/shared_preferences.dart';

import '../../../Data/Repositories/sign_in_repositories_impl.dart';

class  AppURLS{
/*  final String Basepath = 'https://ac.alhadiexpress.com.bd';*/
  final String Basepath = 'https://acapi.alhadiexpress.com.bd';

  // Method to fetch the token from SharedPreferences
  Future<String?> getAuthToken() async {
    // First, check the token from the repository
    final repository = SigninRepositoryImpl();

    // Get token from the repository
    String? token = await repository.getToken();
    print('APPURLS Token: $token');
    return token;
  }

}
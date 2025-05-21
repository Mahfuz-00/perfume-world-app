import 'signin_remote_source.dart';
import 'package:http/http.dart' as http;

class RemoteDataSource {
 final AuthenticationRemoteDataSource authDataSource = AuthenticationRemoteDataSource();

  // Expose authentication functionality
  Future<String> authenticateUsingMockJson(String email, String password) async {
    return await authDataSource.authenticateUsingMockJson(email, password);
  }

  Future<String> authenticate(String email, String password) async {
    return await authDataSource.authenticate(email, password);
  }
}

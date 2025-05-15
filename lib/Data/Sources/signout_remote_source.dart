import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Core/Config/Constants/app_urls.dart';

class SignOutRemoteDataSource {
  final http.Client client;

  SignOutRemoteDataSource({required this.client});

  Future<void> logout() async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
    }

    final url = Uri.parse(
        '${AppURLS().Basepath}/api/user/logout'); // Replace with your API URL

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      print('Logged out successfully: ${decodedResponse['message']?? 'No message received'}');
    } else {
      throw Exception('Failed to log out');
    }
  }
}

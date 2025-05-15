import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../Core/Config/Constants/app_urls.dart';

class AuthenticationRemoteDataSource {

  // Authenticate user using mock sign-in data (local)
  Future<String> authenticateUsingMockJson(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final jsonString = await rootBundle.loadString('Assets/Mock/mock_sign_in.json');
      final data = json.decode(jsonString) as List;

      // Check if the email and password match in the mock data
      final user = data.firstWhere(
            (user) => user['email'] == email && user['password'] == password,
        orElse: () => null,
      );

      if (user != null) {
        return user['token']; // Return the token from mock data
      } else {
        throw Exception("Invalid email or password.");
      }
    } catch (e) {
      throw Exception("Error in mock sign-in authentication: $e");
    }
  }

  // Authenticate user using remote URL (actual API)
  Future<String> authenticate(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    print('Authenticating...');
    try {
      print('Authenticating...');
      final response = await http.post(
        Uri.parse('${AppURLS().Basepath}/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Login successful : $responseData');
        return responseData['token'];
      } else {
        throw Exception('Failed to authenticate');
      }
    } catch (e) {
      throw Exception('Error in sign-in authentication: $e');
    }
  }
}

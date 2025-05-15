import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Core/Config/Constants/app_urls.dart';
import '../Models/project.dart';

abstract class ProjectRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchProjects();
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final http.Client client;

  ProjectRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Map<String, dynamic>>> fetchProjects() async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
    }
    final response = await client.get(
      Uri.parse('${AppURLS().Basepath}/api/project/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);  // Decode as Map
      print('Decoded data: $data');

      // Assuming the response structure is a Map with a key 'data' that contains the list
      if (data['data'] != null && data['data'] is List) {
        List<Map<String, dynamic>> projects = List<Map<String, dynamic>>.from(data['data']);
        return projects;
      } else {
        throw Exception('Invalid response format: "data" key is missing or not a list');
      }
    } else {
      throw Exception('Failed to fetch employees');
    }
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Core/Config/Constants/app_urls.dart';
import '../Models/activity.dart';
import 'package:http/http.dart' as http;

class ActivityRemoteDataSource {
  // Fetch tasks from local JSON file (mock data) or remote URL
  Future<List<ActivityModel>> getTasks() async {
    // Load the mock tasks from assets (local mock data)
    /* final jsonString = await rootBundle.loadString('Assets/Mock/task.json');
    final data = json.decode(jsonString) as List;

    // Convert the JSON data into TaskModel list using fromJson
    return data.map((e) => ActivityModel.fromJson(e)).toList();*/

    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
    }

    final response = await http.get(
      Uri.parse('${AppURLS().Basepath}/api/activity/list/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // Include the token in the header
      },
    );

    print('response StatusCode: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      // Decode the response body as a map
      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      // Extract the 'data' field, which is a map of activities
      final Map<String, dynamic> data = decodedResponse['data'];

      data.forEach((key, value) {
        print('Item $key:');
        value.forEach((key, val) {
          print('$key: $val');
        });
        print('-----------------------------');
      });

      // Convert the map of activities to a list of ActivityModel instances
      final List<ActivityModel> activities = data.values.map((e) => ActivityModel.fromJson(e)).toList();

      print('Fetched Activity Dashboard: $activities');
      return activities;
    } else {
      throw Exception('Failed to load activities');
    }
  }
}

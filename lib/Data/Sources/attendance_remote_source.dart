import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Core/Config/Constants/app_urls.dart';

abstract class AttendanceRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchAttendanceRequests();
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final http.Client client;

  AttendanceRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Map<String, dynamic>>> fetchAttendanceRequests() async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle missing token
      print('Authentication token not available.');
      throw Exception('Authentication token not available.');
    }

    print('Token: $authToken');

    try {
      // Make HTTP GET request
      final response = await client.get(
        Uri.parse('${AppURLS().Basepath}/api/attendance/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract the 'data' field
        final List<dynamic> data = responseBody['data'];

        // Map response to List of Map<String, dynamic>
        final List<Map<String, dynamic>> attendanceRequests =
        data.map((e) => Map<String, dynamic>.from(e)).toList();

        print('Fetched Attendance Requests: $attendanceRequests');
        return attendanceRequests;
      } else {
        // Handle non-200 status code
        print('Failed to fetch attendance requests: ${response.reasonPhrase}');
        throw Exception('Failed to fetch attendance requests');
      }
    } catch (e) {
      // Handle errors
      print('Error while fetching attendance requests: $e');
      throw Exception('Error while fetching attendance requests: $e');
    }
  }
}

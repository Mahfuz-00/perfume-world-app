import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../Core/Config/Constants/app_urls.dart';
import '../Models/attendance_form.dart';

class AttendanceFormRemoteDataSource {
  final http.Client client;

  AttendanceFormRemoteDataSource(this.client);

  Future<void> createAttendance(AttendanceFormModel attendance) async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
    }

    print(attendance.toJson());

    final response = await client.post(
      Uri.parse('${AppURLS().Basepath}/api/attendance/request/store'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(attendance.toJson()),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Attendance data sent successfully');
      print(jsonResponse);
      //return jsonResponse;
    } else {
      print('Response Body: ${response.body}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Missing Data :$jsonResponse');
      print(
          'Failed to send attendance data. Status code: ${response.statusCode}');
      throw Exception('Failed to create Attendance: ${response.body}');
    }
  }
}

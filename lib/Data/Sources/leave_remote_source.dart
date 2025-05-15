import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Core/Config/Constants/app_urls.dart';
import '../Models/leave.dart';

class LeaveRemoteSource {
  final http.Client client;

  LeaveRemoteSource({required this.client});

  Future<LeaveModel> fetchLeaveApplications({String? status}) async {
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
      final Uri url = Uri.parse('${AppURLS().Basepath}/api/leave/application/');
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Include token in header
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body); // Decoding the response as a Map
        final String remainingDays = data['data']['remainingDays'].toString(); // Extracting remainingDays
        final List<dynamic> leaveData = data['data']['record']; // Extracting the 'record' list from the 'data' map

        print('Fetched Leave Data: $leaveData');

        // Pass remainingDays and leaveData to the LeaveModel constructor
        LeaveModel leaveModel = LeaveModel(
          remainingDays: remainingDays,
          leaveRecords: leaveData.map((item) => LeaveRecordModel.fromJson(item)).toList(),
        );

        return leaveModel;
      } else {
        throw Exception('Failed to load leave applications');
      }
    } catch (e) {
      throw Exception('Error fetching leave applications: $e');
    }
  }
}

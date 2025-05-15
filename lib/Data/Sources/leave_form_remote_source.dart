import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Core/Config/Constants/app_urls.dart';
import '../Models/leave_form.dart';

class LeaveFormRemoteSource {
  final http.Client client;

  LeaveFormRemoteSource(this.client);

  // Submit leave form
  Future<void> submitLeaveForm(LeaveFormModel leaveForm) async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
    }

    print(leaveForm.toJson());

    final response = await client.post(
      Uri.parse('${AppURLS().Basepath}/api/leave/application/store'),
      headers: {'Content-Type': 'application/json',  'Authorization': 'Bearer $authToken',},
      body: jsonEncode(leaveForm.toJson()),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Leave data sent successfully');
      print(jsonResponse);
      //return jsonResponse;
    } else {
      print('Response Body: ${response.body}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Missing Data :$jsonResponse');
      print(
          'Failed to send leave data. Status code: ${response.statusCode}');
      throw Exception('Failed to create Leave: ${response.body}');
    }
  }
}

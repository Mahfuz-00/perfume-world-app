import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Core/Config/Constants/app_urls.dart';
import '../Models/activity_form.dart';

class ActivityFormRemoteDataSource {
  final http.Client client;

  ActivityFormRemoteDataSource(this.client);

  Future<void> createActivity(ActivityFormModel activity) async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
    }

    final url = Uri.parse('${AppURLS().Basepath}/api/activity/task/store');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({
        'actvTitle': activity.title,
        'actvProject': activity.project,
        'actvStartDate': activity.startDate,
        'actvEndDate': activity.endDate,
        'actvEstimatedHour': activity.estimatedHour,
     /*   'actvProjectUser': activity.assignedEmployee,*/
        'actvDescription': activity.description,
        'priority': activity.priority,
        'status': activity.status,
      }),
    );
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Activity data sent successfully');
      print(jsonResponse);
      //return jsonResponse;
    } else {
      print('Response Body: ${response.body}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print('Missing Data :$jsonResponse');
      print(
          'Failed to send activity data. Status code: ${response.statusCode}');
      throw Exception('Failed to create activity: ${response.body}');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/Config/Constants/app_urls.dart';
import '../../Domain/Entities/dashboard_entities.dart';
import '../../Domain/Entities/product_entities.dart';
import '../Models/dashboard.dart';
import '../Models/product_model.dart';

abstract class DashboardRemoteSource {
  Future<List<ProductEntity>> fetchDashboardData();
}

class DashboardRemoteSourceImpl implements DashboardRemoteSource {
  final http.Client client;

  DashboardRemoteSourceImpl({required this.client});

  @override
  Future<List<ProductEntity>> fetchDashboardData() async {
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

    final response = await client.get(
      // Uri.parse('${AppURLS().Basepath}/api/dashboard'),
      Uri.parse('${AppURLS().Basepath}/api/pos/product/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // Include token in header
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> productList = jsonResponse['data'];
      return productList.map((json) => ProductModel.fromJson(json).toEntity()).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }


    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> responseBody = jsonDecode(response.body);
    //
    //   // Print each section of the response separately
    //   // Print 'message' and its type
    //   print('Message: ${responseBody['message']}');
    //   print('Message Type: ${responseBody['message'].runtimeType}'); // Type of 'message'
    //
    //   // Iterate over 'activities' and print each data item with its type
    //   final activities = responseBody['data']['activities'];
    //   print('Activities: $activities');
    //   if (activities is Map<String, dynamic>) {
    //     activities.forEach((key, value) {
    //       print('$key: $value');
    //       print('$key Type: ${value.runtimeType}');
    //     });
    //   } else {
    //     print('Activities is not a Map, type: ${activities.runtimeType}');
    //   }
    //
    //   // Iterate over 'UsedLeave' and print each data item with its type
    //   final ActivitiesPending = responseBody['data']['ActivitiesPanding'];
    //   print('Activities Pending: ${ActivitiesPending}');
    //   print('Activities Pending Type: ${ActivitiesPending.runtimeType}');
    //
    //   // Iterate over 'AvailableLeave' and print each data item with its type
    //   final availableLeave = responseBody['data']['AvailableLeave'];
    //   print('Available Leave: ${availableLeave}');
    //   print('Available Leave Type: ${availableLeave.runtimeType}');
    //
    //   // Iterate over 'UsedLeave' and print each data item with its type
    //   final usedLeave = responseBody['data']['UsedLeave'];
    //   print('Used Leave: ${usedLeave}');
    //   print('Used Leave Type: ${usedLeave.runtimeType}');
    //
    //   // Iterate over 'attendance' and print each data item with its type
    //   final attendance = responseBody['data']['attendance'];
    //   print('Attendance: $attendance');
    //   if (attendance is Map<String, dynamic>) {
    //     attendance.forEach((key, value) {
    //       print('$key: $value');
    //       print('$key Type: ${value.runtimeType}');
    //     });
    //   } else {
    //     print('Attendances is not a Map, type: ${attendance.runtimeType}');
    //   }
    //
    //   // Iterate over 'voucher' and print each data item with its type
    //   final voucher = responseBody['data']['voucher'];
    //   print('Voucher: $voucher');
    //   if (voucher is Map<String, dynamic>) {
    //     voucher.forEach((key, value) {
    //       print('$key: $value');
    //       print('$key Type: ${value.runtimeType}');
    //     });
    //   } else {
    //     print('Vouchers is not a Map, type: ${voucher.runtimeType}');
    //   }
    //
    //   final leave = responseBody['data']['leave'];
    //   print('Leave: $leave');
    //   if (leave is Map<String, dynamic>) {
    //     leave.forEach((key, value) {
    //       print('$key: $value');
    //       print('$key Type: ${value.runtimeType}');
    //     });
    //   } else {
    //     print('Leave is not a Map, type: ${leave.runtimeType}');
    //   }
    //
    //   // Extracting the 'data' field
    //   final Map<String, dynamic> data = responseBody['data'];
    //
    //   print('Data: $data');
    //   try {
    //     DashboardModel model = DashboardModel.fromJson(data);
    //     print('Model $model');
    //     return model.toEntity();
    //   } catch (e, stackTrace) {
    //     print('Error deserializing DashboardModel: $e');
    //     print('StackTrace: $stackTrace');
    //     // Optionally, print the data to see what went wrong
    //     print('Response data: $data');
    //   }
    //
    //   // Pass 'data' to DashboardModel fromJson
    //   DashboardModel model = DashboardModel.fromJson(data);
    //
    //   print('Model $model');
    //
    //   // Return the model as DashboardEntity
    //   return model.toEntity(); // Since DashboardModel is a subclass of DashboardEntity
    // } else {
    //   throw Exception('Failed to load dashboard data');
    // }
  }
}

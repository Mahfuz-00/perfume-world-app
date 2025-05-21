import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perfume_world_app/core/config/constants/app_urls.dart';
import 'package:perfume_world_app/data/models/customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getCustomers();
  Future<String> addCustomer(String name, String phone);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final http.Client client;

  CustomerRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CustomerModel>> getCustomers() async {
    AppURLS appURLs = AppURLS();
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      print('Authentication token not available.');
      throw Exception('Authentication token not available.');
    }

    try {
      final response = await client.get(
        Uri.parse('${appURLs.Basepath}/api/pos/customer/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print('GET Response Status Code: ${response.statusCode}');
      print('GET Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> data = responseBody['data'];
        final List<CustomerModel> customers =
        data.map((e) => CustomerModel.fromJson(Map<String, dynamic>.from(e))).toList();
        print('Fetched Customers: $customers');
        return customers;
      } else {
        print('Failed to fetch customers: ${response.reasonPhrase}');
        throw Exception('Failed to fetch customers: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error while fetching customers: $e');
      throw Exception('Error while fetching customers: $e');
    }
  }

  @override
  Future<String> addCustomer(String name, String phone) async {
    AppURLS appURLs = AppURLS();
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      print('Authentication token not available.');
      throw Exception('Authentication token not available.');
    }

    try {
      final response = await client.post(
        Uri.parse('${appURLs.Basepath}/api/pos/customer/store'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'name': name,
          'phone': phone,
        }),
      );

      print('POST Response Status Code: ${response.statusCode}');
      print('POST Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String message = responseBody['message'] as String;
        print('Add Customer Message: $message');
        return message;
      } else {
        print('Failed to add customer: ${response.reasonPhrase}');
        throw Exception('Failed to add customer: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error while adding customer: $e');
      throw Exception('Error while adding customer: $e');
    }
  }
}
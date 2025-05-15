// lib/data/sources/expense_head_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Core/Config/Constants/app_urls.dart';
import '../Models/head_of_accounts.dart';

abstract class ExpenseHeadRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchExpenseHeads();
}

class ExpenseHeadRemoteDataSourceImpl implements ExpenseHeadRemoteDataSource {
  final http.Client client;

  ExpenseHeadRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Map<String, dynamic>>> fetchExpenseHeads() async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
    }

    final response = await client.get(
      Uri.parse('${AppURLS().Basepath}/api/expense/heads'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);  // Decode as Map
      print('Decoded data: $data');

      // Assuming the response structure is a Map with a key 'data' that contains the list
      if (data['data'] != null && data['data'] is List) {
        List<Map<String, dynamic>> headofaccounts = List<Map<String, dynamic>>.from(data['data']);
        return headofaccounts;
      } else {
        throw Exception('Invalid response format: "data" key is missing or not a list');
      }
    } else {
      throw Exception('Failed to fetch head of accounts');
    }
  }
}

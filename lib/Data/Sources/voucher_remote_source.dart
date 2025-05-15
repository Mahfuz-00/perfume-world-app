import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Core/Config/Constants/app_urls.dart';
import '../Models/voucher.dart';

abstract class VoucherRemoteDataSource {
  Future<List<VoucherModel>> fetchVouchers();
}

class VoucherRemoteDataSourceImpl implements VoucherRemoteDataSource {
  final http.Client client;

  VoucherRemoteDataSourceImpl({required this.client});

  @override
  Future<List<VoucherModel>> fetchVouchers() async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
    }

    final response = await client.get(
      Uri.parse('${AppURLS().Basepath}/api/voucher/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // Include the token in the header
      },
    );

    print('response StatusCode: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      // Decode the response body to a Map<String, dynamic>
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // Extract the 'data' field, which is a List of voucher data
      final List<dynamic> data = responseBody['data'];

      // Map the List of dynamic objects (voucher data) to a List of VoucherModel
      return data.map((json) => VoucherModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vouchers');
    }
  }
}

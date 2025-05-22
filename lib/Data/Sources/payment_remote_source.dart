// lib/data/datasources/payment_method_remote_data_source_impl.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perfume_world_app/Core/Config/Constants/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/payment.dart';
import '../Repositories/payment_repositories_impl.dart';

abstract class PaymentMethodRemoteDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
}

class PaymentMethodRemoteDataSourceImpl implements PaymentMethodRemoteDataSource {
  final http.Client client;

  PaymentMethodRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    AppURLS appURLs = AppURLS();
    String? authToken = await appURLs.getAuthToken();
    if (authToken == null) throw Exception('Authentication token not available.');

    final response = await client.get(
      Uri.parse('${appURLs.Basepath}/api/pos/payment/method'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Accept': 'application/json',
      },
    );

    print('GET Response Status Code: ${response.statusCode}');
    print('GET Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // Assuming the API returns a list directly
      final List<dynamic> data = jsonResponse is List ? jsonResponse : jsonResponse['data'];
      return data.map((json) => PaymentMethodModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load payment methods: ${response.statusCode}');
    }
  }
}
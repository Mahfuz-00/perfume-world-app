// lib/data/sources/invoice_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perfume_world_app/core/config/constants/app_urls.dart';
import '../Models/Collection.dart';
import '../Models/invoice.dart';

abstract class InvoiceRemoteDataSource {
  Future<String> submitInvoice(InvoiceModel invoice);
  Future<String> submitCollection(CollectionModel collection);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final http.Client client;

  InvoiceRemoteDataSourceImpl({required this.client});

  @override
  Future<String> submitInvoice(InvoiceModel invoice) async {
    AppURLS appURLs = AppURLS();
    String? authToken = await appURLs.getAuthToken();
    if (authToken == null) throw Exception('Authentication token not available.');


    print('Invoice : ${invoice.toJson()}');

    final response = await client.post(
      // Uri.parse('${appURLs.Basepath}/api/pos/collection/store'),
      Uri.parse('${appURLs.Basepath}/api/pos/store'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(invoice.toJson()),
    );

    print('GET Response Status Code: ${response.statusCode}');
    print('GET Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return responseBody['message'] as String;
    } else {
      throw Exception('Failed to submit invoice: ${response.reasonPhrase}');
    }
  }

  @override
  Future<String> submitCollection(CollectionModel collection) async {
    AppURLS appURLs = AppURLS();
    String? authToken = await appURLs.getAuthToken();
    if (authToken == null) throw Exception('Authentication token not available.');

    final response = await client.post(
      // Uri.parse('${appURLs.Basepath}/api/pos/get/store'),
      Uri.parse('${appURLs.Basepath}/api/pos/collection/store'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(collection.toJson()),
    );

    print('GET Response Status Code: ${response.statusCode}');
    print('GET Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return responseBody['message'] as String;
    } else {
      throw Exception('Failed to submit collection: ${response.reasonPhrase}');
    }
  }
}
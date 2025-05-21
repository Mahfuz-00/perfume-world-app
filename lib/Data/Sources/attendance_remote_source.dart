// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:perfume_world_app/core/config/constants/app_urls.dart';
// import 'package:perfume_world_app/data/models/customer_model.dart';
//
// abstract class CustomerRemoteDataSource {
//   Future<List<CustomerModel>> getCustomers();
// }
//
// class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
//   final http.Client client;
//
//   CustomerRemoteDataSourceImpl({required this.client});
//
//   @override
//   Future<List<CustomerModel>> getCustomers() async {
//     AppURLS appURLs = AppURLS();
//
//     // Fetch the token
//     String? authToken = await appURLs.getAuthToken();
//     print('Token: $authToken');
//
//     if (authToken == null) {
//       print('Authentication token not available.');
//       throw Exception('Authentication token not available.');
//     }
//
//     try {
//       // Make HTTP GET request
//       final response = await client.get(
//         Uri.parse('${appURLs.Basepath}/api/pos/customer/'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $authToken',
//         },
//       );
//
//       print('Response Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         // Decode the response body
//         final Map<String, dynamic> responseBody = json.decode(response.body);
//
//         // Extract the 'data' field
//         final List<dynamic> data = responseBody['data'];
//
//         // Map response to List<CustomerModel>
//         final List<CustomerModel> customers =
//         data.map((e) => CustomerModel.fromJson(Map<String, dynamic>.from(e))).toList();
//
//         print('Fetched Customers: $customers');
//         return customers;
//       } else {
//         print('Failed to fetch customers: ${response.reasonPhrase}');
//         throw Exception('Failed to fetch customers: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       print('Error while fetching customers: $e');
//       throw Exception('Error while fetching customers: $e');
//     }
//   }
// }
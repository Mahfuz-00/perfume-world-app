import 'dart:convert';
import 'dart:io'; // For File handling
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart'; // Import mime package

import '../../Core/Config/Constants/app_urls.dart';

class VoucherFormRemoteDataSource {
  final http.Client client;

  VoucherFormRemoteDataSource(this.client);

  Future<void> submitVoucherForm(Map<String, dynamic> voucher) async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
      return; // Return early if token is not available
    }

    // Prepare the URL for the API request
    final url = '${AppURLS().Basepath}/api/voucher/store';

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Authorization'] = 'Bearer $authToken'
      ..fields['date'] = voucher['date']
      ..fields['cost_center_id'] = voucher['cost_center_id'].toString()
      ..fields['description'] = voucher['description']
      ..fields['paid_status'] = voucher['paid_status'];
    // Convert account_ids and amounts to raw arrays (no encoding here)
    if (voucher['account_ids'] is List<String>) {
      for (var accountId in voucher['account_ids']) {
        request.fields['account_ids[]'] =
            accountId; // Send each account ID as a separate field
      }
    }
    if (voucher['amounts'] is List<double>) {
      for (var amount in voucher['amounts']) {
        request.fields['amounts[]'] =
            amount.toString(); // Send each amount as a separate field
      }
    }

    // Check if there's an attachment (file) to upload
    if (voucher['attachment'] != null) {
      // Check if the attachment is a File object or a file path (String)
      File attachmentFile;

      // If the attachment is a path (String), convert it to File
      if (voucher['attachment'] is String) {
        attachmentFile = File(voucher['attachment']); // Convert path to File
      } else if (voucher['attachment'] is File) {
        attachmentFile = voucher['attachment']; // Use the File directly
      } else {
        throw Exception('Attachment is not a valid file or file path');
      }

      // Get the MIME type of the file using the mime package
      String? mimeType = lookupMimeType(attachmentFile.path);

      // Create a multipart file from the attachment file object
      var multipartFile = await http.MultipartFile.fromPath(
        'attachment', // Name of the field in the form data
        attachmentFile.path, // File path
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      );

      // Add the file to the request
      request.files.add(multipartFile);
    }

    try {
      // Send the request
      final response = await request.send();

      // Listen for the response and get the status code and response body
      final responseBody = await response.stream.bytesToString();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        print('Voucher data sent successfully');
        print(jsonResponse);
        // Process the response as needed
      } else {
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        print(
            'Failed to send voucher data. Status code: ${response.statusCode}');
        print('Error: $jsonResponse');
        throw Exception('Failed to create Voucher: $responseBody');
      }
    } catch (e) {
      print('Error during request: $e');
      throw Exception('Error during request: $e');
    }
  }
}

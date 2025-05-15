// lib/data/datasources/profile_remote_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Core/Config/Constants/app_urls.dart';
import '../Models/profile.dart';
import '../../Domain/Entities/profile_entities.dart';
import '../../Domain/Repositories/profile_repositories.dart';

abstract class ProfileRemoteSource {
  Future<ProfileEntity> fetchProfile();
}

class ProfileRemoteSourceImpl implements ProfileRemoteSource {
  final http.Client client;

  ProfileRemoteSourceImpl({required this.client});

  @override
  Future<ProfileEntity> fetchProfile() async {
    AppURLS appURLs = AppURLS();

    // Fetch the token using the AppURLS class
    String? authToken = await appURLs.getAuthToken();
    print('Token: $authToken');

    if (authToken == null) {
      // Handle the case when the token is not available
      print('Token is not available.');
    }

    print('Fetching profile');

    final response = await client.get(
      Uri.parse('${AppURLS().Basepath}/api/user/profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken', // Include the token in the header
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

      // Check if the 'data' key is present in the response
      if (decodedResponse['data'] != null) {
        var data = decodedResponse['data'];
        print('Profile Data: $data');

        // Create Profile instance using the data inside the 'data' field
        final profile = ProfileModel.fromJson(data);
        print('Profile Name: ${profile.name}'); // Debugging the profile name

        // Return ProfileEntity created from the Profile model
        return ProfileEntity.fromModel(profile);
      } else {
        throw Exception('No data found in the response');
      }
    } else {
      throw Exception('Failed to load profile');
    }
  }
}

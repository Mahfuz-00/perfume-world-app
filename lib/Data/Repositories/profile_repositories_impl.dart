import '../../Domain/Entities/profile_entities.dart';
import '../../Domain/Repositories/profile_repositories.dart';
import '../Sources/profile_remote_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteSource remoteSource;

  ProfileRepositoryImpl({required this.remoteSource});

  @override
  Future<ProfileEntity> getProfile() async {
    try {
      final profile = await remoteSource.fetchProfile();
      print('Repository Implementation : $profile');
      print('Profile Name Implementation :${profile.name}');
      print('Profile Email Implementation :${profile.email}');
      print('Profile Phone Implementation :${profile.phoneNumber}');
      print('Profile Photo Implementation :${profile.photoUrl}');
      print('Profile Designation Implementation :${profile.designation}');
      print('Profile Department Implementation :${profile.department}');
      print('Profile EmployeeID Implementation :${profile.employeeID}');

      return profile;
    } catch (e) {
      throw Exception('Failed to fetch profile from remote source: $e');
    }
  }
}
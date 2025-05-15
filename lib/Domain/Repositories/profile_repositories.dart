import '../Entities/profile_entities.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
}
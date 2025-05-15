import '../Entities/profile_entities.dart';
import '../Repositories/profile_repositories.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase({required this.repository});

  Future<ProfileEntity> execute() async {
    return await repository.getProfile();
  }
}

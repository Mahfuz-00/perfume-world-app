import '../Entities/project_entities.dart';
import '../Repositories/project_repositories.dart';

class GetProjectsUseCase {
  final ProjectRepository repository;

  GetProjectsUseCase({required this.repository});

  Future<List<ProjectEntity>> execute() {
    return repository.getProjects();
  }
}

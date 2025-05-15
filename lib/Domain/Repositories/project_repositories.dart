import '../Entities/project_entities.dart';

abstract class ProjectRepository {
  Future<List<ProjectEntity>> getProjects();
}

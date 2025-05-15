import '../../Domain/Entities/project_entities.dart';
import '../../Domain/Repositories/project_repositories.dart';
import '../Sources/project_remote_source.dart';
import '../Models/project.dart'; // Make sure to import your ProjectModel

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProjectEntity>> getProjects() async {
    // Fetch the raw project models from the remote data source
    final projectModels = await remoteDataSource.fetchProjects();

    // Convert the ProjectModel to your domain entity (ProjectEntity)
    return projectModels.map((model) => ProjectModel.fromJson(model)).toList();
  }
}

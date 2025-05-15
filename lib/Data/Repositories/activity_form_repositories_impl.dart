import '../../Domain/Entities/activity_form_entities.dart';
import '../../Domain/Repositories/activity_form_repositories.dart';
import '../Models/activity_form.dart';
import '../Sources/activity_form_remote_source.dart';


class ActivityFormRepositoryImpl implements ActivityFormRepository {
  final ActivityFormRemoteDataSource remoteDataSource;

  ActivityFormRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createActivity(ActivityFromEntity activity) async {
    final activityModel = ActivityFormModel(
      title: activity.title,
      project: activity.project,
      startDate: activity.startDate,
      endDate: activity.endDate,
      estimatedHour: activity.estimatedHour,
   /*   assignedEmployee: activity.AssignedEmployee,*/
      description: activity.description,
      priority: activity.priority,
      status: activity.status,
    );
    return await remoteDataSource.createActivity(activityModel);
  }
}

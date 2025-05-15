import '../Entities/activity_entities.dart';

abstract class ActivityRepository {
  Future<List<ActivityEntity>> fetchTasks();
  Future<void> saveTasksToLocal(List<ActivityEntity> tasks);
  Future<List<ActivityEntity>> getLocalTasks();
  Future<void> deleteOldTasks();
}

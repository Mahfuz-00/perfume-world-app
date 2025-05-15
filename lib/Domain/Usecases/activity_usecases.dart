import '../Entities/activity_entities.dart';
import '../Repositories/activity_repositories.dart';

class ActivityUseCase {
  final ActivityRepository repository;

  ActivityUseCase(this.repository);

  Future<List<ActivityEntity>> execute() async {
    try {
      // Step 1: Fetch tasks from the local data source first (for faster loading)
      final localTasks = await repository.getLocalTasks();
      print('Tasks fetched from local storage -- UseCase:');
      print(localTasks);

      // Step 5: Optionally, delete old tasks if necessary
      await repository.deleteOldTasks();

      // Step 2: Fetch tasks from the remote data source (API)
      final remoteTasks = await repository.fetchTasks();
      print('Tasks fetched from remote storage -- UseCase:');
      print(remoteTasks);

      // Step 3: Combine tasks from both sources
      // In the ActivityUseCase class, modify the task handling to check for null values:
      final allTasks = [...localTasks];

// Add remote tasks that do not already exist in local tasks
      remoteTasks.forEach((remoteTask) {
        // Check if the task title is null or missing
        if (!localTasks.any((localTask) => localTask.title == remoteTask.title)) {
          allTasks.add(remoteTask);
        }
      });

// Ensure non-null values for each task field (you can replace `null` with default values if necessary)
      final cleanedTasks = allTasks.map((task) {
        return ActivityEntity(
          id: task.id,
          title: task.title ?? 'Untitled Task',  // Replace null title with a default string
          projectId: task.projectId,
          startDate: task.startDate,
          endDate: task.endDate,
          estimateHours: task.estimateHours,
          assignor: task.assignor,
          description: task.description ?? 'No description',  // Replace null description with default text
          priority: task.priority,
          status: task.status ?? 'Unknown',  // Replace null status with default text
          updatedAt: task.updatedAt,
          assignedUsers: task.assignedUsers ?? [],
        );
      }).toList();

      print('Cleaned tasks:');
      print(cleanedTasks);

      // Step 4: Save the cleaned tasks to local storage
      await repository.saveTasksToLocal(cleanedTasks);
      print('Cleaned tasks saved to local storage -- UseCase');

      // Step 6: Fetch the tasks from local storage after saving and delete old tasks
      final updatedLocalTasks = await repository.getLocalTasks();
      print('Tasks fetched from local storage after update -- UseCase:');
      print(updatedLocalTasks);

      return allTasks;
    } catch (e) {
      print('Error in FetchTasksUseCase: $e');
      throw Exception('Failed to fetch and combine tasks: $e');
    }
  }
}


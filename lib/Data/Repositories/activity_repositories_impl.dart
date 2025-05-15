import 'dart:convert';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import '../../Domain/Entities/activity_entities.dart';
import '../../Domain/Repositories/activity_repositories.dart';
import '../Models/activity.dart';
import '../Sources/local_data_sources.dart';
import '../Sources/remote_data_sources.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  ActivityRepositoryImpl(this.remoteDataSource, this.localDataSource);

  void logTasks(String title, List<dynamic> tasks) {
    print('--------------------------------');
    print('$title:');
    for (var task in tasks) {
      print('\tTask ID: ${task.id}');
      print('\tTitle: ${task.title}');
      print('\tPriority: ${task.priority}');
      print('\tStart Date: ${task.startDate}');
      print('\tEnd Date: ${task.endDate}');
      print(''); // Adds a blank line between tasks for better readability
    }
    print('--------------------------------');
  }


  @override
  Future<List<ActivityEntity>> fetchTasks() async {
    try {
      final List<ActivityEntity> localTasks = await getLocalTasks();
      logTasks('Local Activities', localTasks);

      final List<ActivityModel> remoteTasks = await remoteDataSource.getTasks();
      logTasks('Remote Activities', remoteTasks.map((e) => e.toEntity()).toList());

      final localTaskKeys = localTasks.map((task) =>
      '${task.title?.toLowerCase()}-${task.priority}-${task.startDate}'
      ).toSet();

      final newTasks = remoteTasks.where((remoteTask) {
        final remoteKey = '${remoteTask.title?.toLowerCase()}-${remoteTask.priority}-${remoteTask.startDate}';
        return !localTaskKeys.contains(remoteKey);
      }).toList();

      if (newTasks.isNotEmpty) {
        final newEntities = newTasks.map((task) => task.toEntity()).toList();
        await saveTasksToLocal(newEntities);
        print('New tasks saved to local database.');
      }

      final allTasks = [...localTasks, ...newTasks.map((task) => task.toEntity()).toList()];
      logTasks('Combined Tasks (Local + New)', allTasks);

      return allTasks;
    } catch (e, stackTrace) {
      print('Error fetching tasks: $e');
      print(stackTrace);
      rethrow;
    }
  }


  @override
  Future<void> saveTasksToLocal(List<ActivityEntity> tasks) async {
    try {
      // Fetch existing tasks from local data source
      final List<ActivityEntity> existingTasks = await getLocalTasks();
      print('Existing activities in local database:');
      existingTasks.forEach((task) {
        print('Task Header: ${task.title}, Task Priority: ${task.priority}, Task Date: ${task.startDate}');
      });

      // Convert TaskEntity to TaskModel before saving
      final List<ActivityModel> taskModelsToSave = tasks.map((task) => ActivityModel.fromEntity(task)).toList();
      print('Converting activities to activityModel:');
      taskModelsToSave.forEach((task) {
        print('Task Header: ${task.title}, Task Priority: ${task.priority}, Task Date: ${task.startDate}');
      });

      // Check if the task already exists in the local database (by comparing taskHeader, priority, and date)
      final List<ActivityModel> uniqueTasks = taskModelsToSave.where((taskToSave) {
        return !existingTasks.any((existingTask) =>
        existingTask.title == taskToSave.title &&
            existingTask.priority == taskToSave.priority &&
            existingTask.startDate == taskToSave.startDate);
      }).toList();

      print('Unique activities to be saved:');
      uniqueTasks.forEach((task) {
        print('Task Header: ${task.title}, Task Priority: ${task.priority}, Task Date: ${task.startDate}');
      });

      // Save only unique tasks to local storage
      if (uniqueTasks.isNotEmpty) {
        // Directly save as ActivityModel (do not convert to ActivityEntity)
        await localDataSource.saveTasks(uniqueTasks);
        print('Successfully saved unique tasks to local storage.');
      } else {
        print('No new unique tasks to save.');
      }
    } catch (e) {
      // Handle errors (e.g., database errors)
      print('Error occurred while saving activities: $e');
      if (e is DatabaseException) {
        print('Database error: ${e.toString()}'); // Use e.toString() to access the full error message
      } else if (e is SocketException) {
        print('Network error: ${e.message}');
      } else {
        print('Unknown error: ${e.toString()}');
      }
      throw Exception('Failed to save activities to local storage: $e');
    }
  }

  @override
  Future<List<ActivityEntity>> getLocalTasks() async {
    try {
      // Fetch tasks from local data source (database or shared preferences)
      final List<ActivityModel> taskModels = await localDataSource.getTasks();
      // Iterate through each task and print field-specific null checks
      taskModels.forEach((task) {
        print('activity Header: ${task.title ?? 'null'}');
        print('Task Name: ${task.title ?? 'null'}');
        print('Task Priority: ${task.priority ?? 'null'}');
        print('Task Date: ${task.startDate ?? 'null'}');
        print('Task End Date: ${task.endDate ?? 'null'}');
        print('Estimate Hours: ${task.estimateHours ?? 'null'}');
        print('Assignor: ${task.assignor ?? 'null'}');
        print('Description: ${task.description ?? 'null'}');
        print('Comment: ${task.comment ?? 'null'}');
        print('Status: ${task.status ?? 'null'}');
        print('UpdatedAt: ${task.updatedAt ?? 'null'}');
        print('Assigned Users: ${task.assignedUsers?.map((user) => user.name ?? 'null') ?? 'null'}');
      });

      print('Local activities retrieved from local data source:');
      taskModels.forEach((task) {
        print('activity Header: ${task.title}, Task Name: ${task.title}, Task Priority: ${task.priority}, Task Date : ${task.startDate}');
      });

      // Convert TaskModel to TaskEntity and return
      return taskModels.map((taskModel) => taskModel.toEntity()).toList();
    } catch (e) {
      // Handle errors (e.g., database errors)
      print('Error fetching activities from local storage:');

      final List<ActivityModel> taskModels = await localDataSource.getTasks();

      // Try to print the null field causing the issue
      try {
        if (taskModels.isEmpty) {
          print('No tasks found in local storage.');
        } else {
          // Check if any task has a null value and print it
          for (var task in taskModels) {
            print('Checking task: ${task.title}');
            if (task.title == null) print('Task title is null');
            if (task.priority == null) print('Task priority is null');
            if (task.startDate == null) print('Task startDate is null');
            if (task.endDate == null) print('Task endDate is null');
            if (task.estimateHours == null) print('Task estimateHours is null');
            if (task.assignor == null) print('Task assignor is null');
            if (task.description == null) print('Task description is null');
            if (task.comment == null) print('Task comment is null');
            if (task.status == null) print('Task status is null');
            if (task.updatedAt == null) print('Task updatedAt is null');
            if (task.assignedUsers == null) print('Assigned users are null');
            else {
              task.assignedUsers!.forEach((user) {
                if (user.name == null) print('Assigned user name is null');
                if (user.profilePhotoPath == null) print('Assigned user profilePhotoPath is null');
              });
            }
          }
        }
      } catch (innerError) {
        print('Error while checking task data for null fields: $innerError');
      }
      throw Exception('Failed to fetch activities from local storage: $e');
    }
  }

  @override
  Future<void> deleteOldTasks() async {
    try {
      // Delete old tasks from local data source
      await localDataSource.deleteOldTasks();
      print('Old activities deleted from local data source');
    } catch (e) {
      // Handle errors (e.g., database errors)
      print('Error deleting old activities: $e');
      throw Exception('Failed to delete old activities: $e');
    }
  }
}

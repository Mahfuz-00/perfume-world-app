import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../Models/activity.dart';

class LocalDataSource {
  final Database db;

  LocalDataSource(this.db);

  // Save tasks with aligned keys
  Future<void> saveTasks(List<ActivityModel> tasks) async {
    for (final task in tasks) {
      try {
        // Get task data as JSON
        final taskData = task.toJson();

        // Remap fields to match the database schema, handling null or empty values explicitly

        // Handle 'start_date' mapping
        taskData['start_date'] = taskData['start_date']?.isNotEmpty ?? false ? taskData['start_date'] : null;

        // Handle 'end_date' mapping
        taskData['end_date'] = taskData['end_date']?.isNotEmpty ?? false ? taskData['end_date'] : null;

        // Handle 'updated_at' mapping
        taskData['updated_at'] = taskData['updated_at']?.isNotEmpty ?? false ? taskData['updated_at'] : null;

        // Map 'estimate_hours' to 'estimateHours'
        taskData['estimate_hours'] = taskData['estimate_hours']?.isNotEmpty ?? false ? taskData['estimate_hours'] : null;

        // Handle 'assigned_users' field
        if (taskData['assigned_users'] != null && taskData['assigned_users'] is List) {
          // Ensure 'assigned_users' is a List before encoding it to a string
          taskData['assigned_users'] = jsonEncode(taskData['assigned_users'] as List);
        } else {
          taskData['assigned_users'] = null; // Set to null if it's not a list
        }

        // Handle 'priority' field
        taskData['priority'] = taskData['priority']?.isNotEmpty ?? false ? taskData['priority'] : null;

        // Handle 'description' field
        taskData['description'] = taskData['description']?.isNotEmpty ?? false ? taskData['description'] : null;

        // Handle 'comment' field
        taskData['comment'] = taskData['comment']?.isNotEmpty ?? false ? taskData['comment'] : null;

        // Handle 'project' field
        taskData['project'] = taskData['project']?.isNotEmpty ?? false ? taskData['project'] : null;

        // Handle 'assignor' field
        taskData['assignor'] = taskData['assignor'] != 0 ? taskData['assignor'] : null;

        // Handle 'status' field
        taskData['status'] = taskData['status']?.isNotEmpty ?? false ? taskData['status'] : null;

        print("Before saving, task data: $taskData");

        // Insert or replace task in the database
        await db.insert(
          'tasks',
          taskData,
          conflictAlgorithm: ConflictAlgorithm.replace, // Insert or update task data
        );

        print("Task successfully saved: $taskData");
      } catch (e) {
        print("Failed to save task: ${task.title}, Error: $e");
      }
    }
  }


// Fetch tasks from the local database
  Future<List<ActivityModel>> getTasks() async {
    final result = await db.query('tasks');
    if (result.isEmpty) {
      return []; // Return an empty list if no tasks are found
    }

    return result.map((taskData) {
      // Create a mutable copy of the taskData to avoid modification on a read-only object
      final taskDataCopy = Map<String, dynamic>.from(taskData);

      // Decode 'assigned_users' if it's a JSON string (and it's not null)
      if (taskDataCopy['assigned_users'] != null) {
        try {
          // Check if assigned_users is a String and decode it
          if (taskDataCopy['assigned_users'] is String) {
            taskDataCopy['assigned_users'] = jsonDecode(taskDataCopy['assigned_users'] as String);
          }
        } catch (e) {
          taskDataCopy['assigned_users'] = []; // Fallback to an empty list if decoding fails
        }
      }

      // Return the ActivityModel object after modifying the mutable taskData
      return ActivityModel.fromJson(taskDataCopy);
    }).toList();
  }



  // Delete old tasks from the local database
  Future<void> deleteOldTasks() async {
    final cutoffDate = DateTime.now().subtract(Duration(days: 15));
    await db.delete('tasks',
        where: 'updated_At < ?', whereArgs: [cutoffDate.toIso8601String()]);
  }
}

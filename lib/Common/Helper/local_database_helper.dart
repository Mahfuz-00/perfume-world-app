import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  static Future<Database> initializeDatabase() async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks_database.db');


    /* comment TEXT, -- Stored as a JSON string*/
    /*  assignorId TEXT,*/
    _database = await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER NOT NULL PRIMARY KEY,
            title TEXT NOT NULL,
            project TEXT,
            start_date TEXT,   -- Changed from startDate to start_date
            end_date TEXT,     -- Changed from endDate to end_date
            estimate_hours TEXT, -- Changed from estimateHours to estimate_hours
            assignor INTEGER,
            description TEXT,
            comment TEXT,
            priority TEXT,
            status TEXT,
            updated_at TEXT,    -- Changed from updatedAt to updated_at
            assigned_users TEXT -- Stored as a JSON string
          )
      ''');
      },
    );

    return _database!;
  }

  // Method to remove duplicates by taskHeader
  static Future<void> removeDuplicates() async {
    final db = await initializeDatabase();

    // Query all tasks from the database
    List<Map<String, dynamic>> rows = await db.query('tasks');

    // Check for duplicates based on taskHeader
    Set<String> seenHeaders = {}; // To track already seen taskHeaders
    for (var row in rows) {
      String taskHeader = row['title'];

      if (seenHeaders.contains(taskHeader)) {
        // Duplicate found, delete the task
        await db.delete(
          'tasks',
          where: 'title = ?',
          whereArgs: [taskHeader],
        );
        print('Deleted duplicate task with taskHeader: $taskHeader');
      } else {
        // Mark taskHeader as seen
        seenHeaders.add(taskHeader);
      }
    }
  }

  // Method to print database structure and data
  static Future<void> printDatabaseStructureAndData() async {
    final db = await initializeDatabase();

    if (db == null) {
      print("Database is not initialized.");
      return;
    }

    // Print table structure (columns)
    List<Map<String, dynamic>> columns =
        await db.rawQuery('PRAGMA table_info(tasks)');
    print("Columns in 'tasks' table:");
    columns.forEach((column) {
      print('Column: ${column['name']}, Type: ${column['type']}');
    });

    // Print all rows in the 'tasks' table
    List<Map<String, dynamic>> rows = await db.query('tasks');
    print("\nRows in 'tasks' table:");
    rows.forEach((row) {
      print(row);
    });
  }
}

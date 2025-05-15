import '../../Domain/Entities/attendance_entities.dart';
import '../../Domain/Repositories/attendance_repositories.dart';
import '../Models/attendance.dart';
import '../Sources/attendance_remote_source.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AttendanceRequest>> getAttendanceRequests() async {
    try {
      // Fetch data from the remote data source
      final remoteData = await remoteDataSource.fetchAttendanceRequests();

      // Convert raw data into a list of AttendanceRequest models
      return remoteData.map((data) => AttendanceRequestModel.fromJson(data)).toList();
    } catch (e) {
      // Handle and rethrow the error
      throw Exception('Error fetching attendance requests: $e');
    }
  }
}


import '../Models/activity_form.dart';
import '../Models/activity.dart';
import '../Models/attendance_form.dart';
import '../Models/leave_form.dart';
import 'activity_form_remote_source.dart';
import 'activity_remote_source.dart';
import 'attendance_form_remote_source.dart';
import 'leave_form_remote_source.dart';
import 'signin_remote_source.dart';
import 'package:http/http.dart' as http;

class RemoteDataSource {
  final ActivityRemoteDataSource taskDataSource = ActivityRemoteDataSource();
  final AuthenticationRemoteDataSource authDataSource = AuthenticationRemoteDataSource();
  final ActivityFormRemoteDataSource activityDataSource = ActivityFormRemoteDataSource(http.Client());
  final LeaveFormRemoteSource leaveFormDataSource = LeaveFormRemoteSource(http.Client());
  final AttendanceFormRemoteDataSource attendanceDataSource = AttendanceFormRemoteDataSource(http.Client());


  // Expose task data fetching functionality
  Future<List<ActivityModel>> getTasks() async {
    return await taskDataSource.getTasks();
  }

  // Expose authentication functionality
  Future<String> authenticateUsingMockJson(String email, String password) async {
    return await authDataSource.authenticateUsingMockJson(email, password);
  }

  Future<String> authenticate(String email, String password) async {
    return await authDataSource.authenticate(email, password);
  }

  // Activity-related functionality
  Future<void> createActivity(ActivityFormModel activity) async {
    return await activityDataSource.createActivity(activity);
  }

  // Expose leave form submission functionality
  Future<void> submitLeaveForm(LeaveFormModel leaveForm) async {
    return await leaveFormDataSource.submitLeaveForm(leaveForm);
  }

  // Expose attendance creation functionality
  Future<void> createAttendance(AttendanceFormModel attendance) async {
    return await attendanceDataSource.createAttendance(attendance);
  }
}

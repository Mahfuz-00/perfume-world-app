import '../Entities/leave_form_entities.dart';

abstract class LeaveFormRepository {
  Future<void> submitLeaveForm(LeaveFormEntity leaveForm);
}


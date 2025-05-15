

import '../../Domain/Entities/leave_form_entities.dart';
import '../../Domain/Repositories/leave_form_repositories.dart';
import '../Models/leave_form.dart';
import '../Sources/remote_data_sources.dart';

class LeaveFormRepositoryImpl implements LeaveFormRepository {
  final RemoteDataSource remoteDataSource;

  LeaveFormRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitLeaveForm(LeaveFormEntity leaveForm) async {
    // Map entity to model
    final leaveFormModel = LeaveFormModel(
      leaveType: leaveForm.leaveType,
      startDate: leaveForm.startDate,
      endDate: leaveForm.endDate,
      totaldays: leaveForm.totaldays,
      responsiblePersonId: leaveForm.responsiblePersonId,
      reason: leaveForm.reason,
    );

    // Submit using the remote data source
    await remoteDataSource.submitLeaveForm(leaveFormModel);
  }
}

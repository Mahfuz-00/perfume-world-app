

import '../Entities/leave_form_entities.dart';
import '../Repositories/leave_form_repositories.dart';

class SubmitLeaveFormUseCase {
  final LeaveFormRepository repository;

  SubmitLeaveFormUseCase(this.repository);

  Future<void> call(LeaveFormEntity leaveForm) async {
    return await repository.submitLeaveForm(leaveForm);
  }
}

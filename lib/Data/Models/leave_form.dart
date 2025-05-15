import '../../Domain/Entities/leave_form_entities.dart';

class LeaveFormModel extends LeaveFormEntity {
  LeaveFormModel({
    dynamic? leaveType,
    dynamic? startDate,
    dynamic? endDate,
    dynamic? totaldays,
    dynamic? responsiblePersonId,
    dynamic? reason,
  }) : super(
    leaveType: leaveType,
    startDate: startDate,
    endDate: endDate,
    totaldays: totaldays,
    responsiblePersonId: responsiblePersonId,
    reason: reason,
  );

  factory LeaveFormModel.fromJson(Map<String, dynamic> json) {
    return LeaveFormModel(
      leaveType: json['leave_type'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      totaldays: json['total_day'] as int?,
      responsiblePersonId: json['responsible_person_id'] as int?,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'total_day': totaldays,
      'responsible_person_id': responsiblePersonId,
      'reason': reason,
    };
  }
}

import '../../Domain/Entities/attendance_form_entities.dart';

class AttendanceFormModel extends AttendanceFormEntities {
  AttendanceFormModel({
    required dynamic inTime,
    required dynamic costCenterId,
    required dynamic description,
  }) : super(
            entryTime: inTime,
            project: costCenterId,
            remark: description);

  factory AttendanceFormModel.fromJson(Map<String, dynamic> json) {
    return AttendanceFormModel(
      inTime: DateTime.parse(json['in_time']),
      costCenterId: json['cost_center_id'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'in_time': entryTime,
      'cost_center_id': project,
      'description': remark,
    };
  }
}

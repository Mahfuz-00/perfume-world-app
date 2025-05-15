import '../../Domain/Entities/leave_entities.dart';

class LeaveModel extends LeaveEntity {
  LeaveModel({
    required String remainingDays,
    required List<LeaveRecordModel> leaveRecords,
  }) : super(
          remainingDays: remainingDays,
          leaveRecords: leaveRecords.map((e) => e.toEntity()).toList(),
        );

  // Factory constructor to create a LeaveModel from JSON
  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      remainingDays: json['data']['remainingDays'].toString(),
      leaveRecords: (json['data']['record'] as List)
          .map((item) => LeaveRecordModel.fromJson(item))
          .toList(),
    );
  }

  // Convert LeaveModel to LeaveEntity
  LeaveEntity toEntity() {
    return LeaveEntity(
      remainingDays: remainingDays,
      leaveRecords: leaveRecords.map((e) => e.toEntity()).toList(),
    );
  }
}

class LeaveRecordModel extends LeaveBodyEntity {
  LeaveRecordModel({
    required int id,
    required int userId,
    required String leaveType,
    required String startDate,
    required String endDate,
    required int totalDay,
    int? responsiblePersonId,
    required String? responsiblePersonName,
    required String reason,
    int? approverId,
    required String status,
    required String createdAt,
    required String updatedAt,
    String? name,
    String? approverPhoto,
  }) : super(
          id: id,
          userId: userId,
          leaveType: leaveType,
          startDate: startDate,
          endDate: endDate,
          totalDay: totalDay,
          responsiblePersonId: responsiblePersonId,
          responsiblePersonName: responsiblePersonName,
          reason: reason,
          approverId: approverId,
          status: status,
          createdAt: createdAt,
          updatedAt: updatedAt,
          name: name,
          approverPhoto: approverPhoto,
        );

  factory LeaveRecordModel.fromJson(Map<String, dynamic> json) {
    return LeaveRecordModel(
      id: json['id'],
      userId: json['user_id'],
      leaveType: json['leave_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalDay: json['total_day'],
      responsiblePersonId: json['responsible_person_id'],
      responsiblePersonName: json['responsible person name'],
      reason: json['reason'],
      approverId: json['approver_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      name: json['approver name'],
      approverPhoto: json['approver_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'total_day': totalDay,
      'responsible_person_id': responsiblePersonId,
      'responsible_person_name': responsiblePersonName,
      'reason': reason,
      'approver_id': approverId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'name': name,
      'approver_photo': approverPhoto,
    };
  }

  // Convert LeaveRecordModel to LeaveRecordEntity
  LeaveBodyEntity toEntity() {
    return LeaveBodyEntity(
      id: id,
      userId: userId,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      totalDay: totalDay,
      responsiblePersonId: responsiblePersonId,
      responsiblePersonName: responsiblePersonName,
      reason: reason,
      approverId: approverId,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      name: name,
      approverPhoto: approverPhoto,
    );
  }
}

class LeaveEntity {
  final String remainingDays;
  final List<LeaveBodyEntity> leaveRecords;

  LeaveEntity({
    required this.remainingDays,
    required this.leaveRecords,
  });

  @override
  String toString() {
    return 'LeaveEntity(remainingDays: $remainingDays, leaveRecords: $leaveRecords)';
  }
}

class LeaveBodyEntity {
  final int id;
  final int userId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final int totalDay;
  final int? responsiblePersonId;
  final String? responsiblePersonName;
  final String reason;
  final int? approverId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? name;
  final String? approverPhoto;

  LeaveBodyEntity({
    required this.id,
    required this.userId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDay,
    this.responsiblePersonId,
    this.responsiblePersonName,
    required this.reason,
    this.approverId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.approverPhoto,
  });

  LeaveBodyEntity toEntity() {
    // This could return a LeaveRecordEntity or other type of entity based on the use case
    return this; // Return the same entity (subclass will override this)
  }
}

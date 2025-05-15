class DashboardEntity {
  final List<ActivityEntity>? activities;
  final dynamic availableLeave;
  final dynamic usedLeave;
  final List<LeaveEntity>? leaves;
  final List<AttendanceEntity>? attendances;
  final List<VoucherEntity>? vouchers;

  DashboardEntity({
    required this.activities,
    required this.availableLeave,
    required this.usedLeave,
    required this.leaves,
    required this.attendances,
    required this.vouchers,
  });
}

class ActivityEntity {
  final int? activityId;
  final int? activityPendingCount;
  final String? activityPriority;
  final String? activityStartDate;
  final String? activityEndDate;
  final String? estimateHours;
  final String? activityStatus;
  final String? title;
  final String? project;
  final String? createdAt;
  final String? assignorName;
  final String? assignorImage;
  final String? projectName;
  List<AssignedUserEntity>? assignedUsers;

  ActivityEntity({
    this.activityId,
    this.activityPendingCount,
    this.activityPriority,
    this.activityStartDate,
    this.activityEndDate,
    this.estimateHours,
    this.activityStatus,
    this.title,
    this.project,
    this.createdAt,
    this.assignorName,
    this.assignorImage,
    this.projectName,
    this.assignedUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'activityPendingCount': activityPendingCount,
      'activityPriority': activityPriority,
      'activityStartDate': activityStartDate,
      'activityEndDate': activityEndDate,
      'estimateHours': estimateHours,
      'activityStatus': activityStatus,
      'title': title,
      'project': project,
      'createdAt': createdAt,
      'assignorName': assignorName,
      'assignorImage': assignorImage,
      'projectName': projectName,
      'assigned_users': assignedUsers?.map((e) => e.toJson()).toList(),
    };
  }

  // Convert ActivityModel to ActivityEntity
  ActivityEntity toEntity() {
    return ActivityEntity(
      activityId: activityId,
      activityPendingCount: activityPendingCount,
      activityPriority: activityPriority,
      activityStartDate: activityStartDate,
      activityEndDate: activityEndDate,
      estimateHours: estimateHours,
      activityStatus: activityStatus,
      title: title,
      project: project,
      createdAt: createdAt,
      assignorName: assignorName,
      assignorImage: assignorImage,
      projectName: projectName,
      assignedUsers: assignedUsers?.map((e) => e.toEntity()).toList(),
    );
  }
}

class LeaveEntity {
  final int? leaveId;
  final int? leaveUserid;
  final String? leaveType;
  final String? leaveStartDate;
  final String? leaveEndDate;
  final String? leaveStatus;
  final String? leaveCreatedAt;
  final String? leaveUpdatedAt;
  final int? leaveDays;
  final String? leaveReason;
  final int? leaveResponsiblePersonId;
  final int? leaveApproverId;
  final String? leaveApproverName;
  final String? leaveApproverImage;

  LeaveEntity({
    this.leaveId,
    this.leaveUserid,
    this.leaveType,
    this.leaveStartDate,
    this.leaveEndDate,
    this.leaveStatus,
    this.leaveCreatedAt,
    this.leaveUpdatedAt,
    this.leaveDays,
    this.leaveReason,
    this.leaveResponsiblePersonId,
    this.leaveApproverId,
    this.leaveApproverName,
    this.leaveApproverImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'leaveId': leaveId,
      'leaveUserid': leaveUserid,
      'leaveType': leaveType,
      'leaveStartDate': leaveStartDate,
      'leaveEndDate': leaveEndDate,
      'leaveStatus': leaveStatus,
      'leaveCreatedAt': leaveCreatedAt,
      'leaveUpdatedAt': leaveUpdatedAt,
      'leaveDays': leaveDays,
      'leaveReason': leaveReason,
      'leaveResponsiblePersonId': leaveResponsiblePersonId,
      'leaveApproverId': leaveApproverId,
      'leaveApproverName': leaveApproverName,
      'leaveApproverImage': leaveApproverImage,
    };
  }

  // Convert Model to Entity
  LeaveEntity toEntity() {
    return LeaveEntity(
      leaveId: leaveId,
      leaveUserid: leaveUserid,
      leaveType: leaveType,
      leaveStartDate: leaveStartDate,
      leaveEndDate: leaveEndDate,
      leaveStatus: leaveStatus,
      leaveCreatedAt: leaveCreatedAt,
      leaveUpdatedAt: leaveUpdatedAt,
      leaveDays: leaveDays,
      leaveReason: leaveReason,
      leaveResponsiblePersonId: leaveResponsiblePersonId,
      leaveApproverId: leaveApproverId,
      leaveApproverName: leaveApproverName,
      leaveApproverImage: leaveApproverImage,
    );
  }
}

class AttendanceEntity {
  final int? attendanceId;
  final int? attendanceUserId;
  final String? inTime;
  final String? outTime;
  final String? deviceIp;
  final String? attendanceProject;
  final String? attendanceCreatedAt;
  final String? attendanceUpdatedAt;
  final String? attendanceUserName;

  AttendanceEntity({
    this.attendanceId,
    this.attendanceUserId,
    this.inTime,
    this.outTime,
    this.deviceIp,
    this.attendanceProject,
    this.attendanceCreatedAt,
    this.attendanceUpdatedAt,
    this.attendanceUserName,
  });

  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'userId': attendanceUserId,
      'inTime': inTime,
      'outTime': outTime,
      'deviceIp': deviceIp,
      'attendanceProject': attendanceProject,
      'attendanceCreatedAt': attendanceCreatedAt,
      'attendanceUpdatedAt': attendanceUpdatedAt,
      'userName': attendanceUserName,
    };
  }

  // Convert Model to Entity
  AttendanceEntity toEntity() {
    return AttendanceEntity(
      attendanceId: attendanceId,
      attendanceUserId: attendanceUserId,
      inTime: inTime,
      outTime: outTime,
      deviceIp: deviceIp,
      attendanceProject: attendanceProject,
      attendanceCreatedAt: attendanceCreatedAt,
      attendanceUpdatedAt: attendanceUpdatedAt,
      attendanceUserName: attendanceUserName,
    );
  }

}

class VoucherEntity {
  final int? voucherId;
  final int? voucherUserId;
  final String? voucherDate;
  final String? voucherProject;
  final int? costCenterId;
  final String? payeeType;
  final String? payeeOthersName;
  final String? voucherCustomerId;
  final String? voucherSupplierId;
  final int? voucherPaidbyId;
  final String? voucherDescription;
  final String? totalAmount;
  final String? voucherPurchaseId;
  final String? voucherSaleId;
  final int? voucherApproverId;
  final String? voucherCreatedAt;
  final String? voucherUpdatedAt;
  final String? costCenterName;
  final String? voucherCustomerName;
  final String? voucherSupplierName;
  final String? voucherPaidByName;
  final String? voucherApproverName;
  final String? voucherStatus;

  VoucherEntity({
    this.voucherId,
    this.voucherUserId,
    this.voucherDate,
    this.voucherProject,
    this.costCenterId,
    this.payeeType,
    this.payeeOthersName,
    this.voucherCustomerId,
    this.voucherSupplierId,
    this.voucherPaidbyId,
    this.voucherDescription,
    this.totalAmount,
    this.voucherPurchaseId,
    this.voucherSaleId,
    this.voucherApproverId,
    this.voucherCreatedAt,
    this.voucherUpdatedAt,
    this.costCenterName,
    this.voucherCustomerName,
    this.voucherSupplierName,
    this.voucherPaidByName,
    this.voucherApproverName,
    this.voucherStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'voucherId': voucherId,
      'voucherUserId': voucherUserId,
      'voucherDate': voucherDate,
      'voucherProject': voucherProject,
      'costCenterId': costCenterId,
      'payeeType': payeeType,
      'payeeOthersName': payeeOthersName,
      'voucherCustomerId': voucherCustomerId,
      'voucherSupplierId': voucherSupplierId,
      'voucherPaidbyId': voucherPaidbyId,
      'voucherDescription': voucherDescription,
      'totalAmount': totalAmount,
      'voucherPurchaseId': voucherPurchaseId,
      'voucherSaleId': voucherSaleId,
      'voucherApproverId': voucherApproverId,
      'voucherCreatedAt': voucherCreatedAt,
      'voucherUpdatedAt': voucherUpdatedAt,
      'costCenterName': costCenterName,
      'voucherCustomerName': voucherCustomerName,
      'voucherSupplierName': voucherSupplierName,
      'voucherPaidByName': voucherPaidByName,
      'voucherApproverName': voucherApproverName,
      'voucherStatus': voucherStatus,
    };
  }

  // Convert Model to Entity
  VoucherEntity toEntity() {
    return VoucherEntity(
      voucherId: voucherId,
      voucherUserId: voucherUserId,
      voucherDate: voucherDate,
      voucherProject: voucherProject,
      costCenterId: costCenterId,
      payeeType: payeeType,
      payeeOthersName: payeeOthersName,
      voucherCustomerId: voucherCustomerId,
      voucherSupplierId: voucherSupplierId,
      voucherPaidbyId: voucherPaidbyId,
      voucherDescription: voucherDescription,
      totalAmount: totalAmount,
      voucherPurchaseId: voucherPurchaseId,
      voucherSaleId: voucherSaleId,
      voucherApproverId: voucherApproverId,
      voucherCreatedAt: voucherCreatedAt,
      voucherUpdatedAt: voucherUpdatedAt,
      costCenterName: costCenterName,
      voucherCustomerName: voucherCustomerName,
      voucherSupplierName: voucherSupplierName,
      voucherPaidByName: voucherPaidByName,
      voucherApproverName: voucherApproverName,
      voucherStatus: voucherStatus,
    );
  }
}


class AssignedUserEntity {
  final int id;
  final String name;
  final String? profilePhotoPath;

  const AssignedUserEntity({
    required this.id,
    required this.name,
    this.profilePhotoPath,
  });

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_photo_path': profilePhotoPath,
    };
  }

  // Convert Model to Entity
  AssignedUserEntity toEntity() {
    return AssignedUserEntity(
      id: id,
      name: name,
      profilePhotoPath: profilePhotoPath,
    );
  }
}

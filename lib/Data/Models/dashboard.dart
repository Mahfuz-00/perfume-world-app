import '../../Domain/Entities/dashboard_entities.dart';

/// A data model for the dashboard containing various attributes like
/// activity details, project details, user information, and voucher details.
// Main Dashboard Model
class DashboardModel extends DashboardEntity{
  DashboardModel({
    required List<ActivityModel>? activities,
    required dynamic availableLeave,
    required dynamic usedLeave,
    required List<LeaveModel>? leaves,
    required List<AttendanceModel>? attendances,
    required List<VoucherModel>? vouchers,
  }) : super(
    activities: activities,
    availableLeave: availableLeave,
    usedLeave: usedLeave,
    leaves: leaves,
    attendances: attendances,
    vouchers: vouchers,
  );

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      activities: (json['activities'] is Map)
          ? [ActivityModel.fromJson(json['activities'])]
          : [],

      availableLeave: json['AvailableLeave'] as dynamic,
      usedLeave: json['UsedLeave'] as dynamic,

      leaves: (json['leave'] is Map)
          ? [LeaveModel.fromJson(json['leave'])]
          : [],

      attendances: (json['attendance'] is Map)
          ? [AttendanceModel.fromJson(json['attendance'])]
          : [],

      vouchers: (json['voucher'] is Map)
          ? [VoucherModel.fromJson(json['voucher'])]
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activities': activities?.map((e) => e.toJson()).toList(),
      'leaves': leaves?.map((e) => e.toJson()).toList(),
      'attendances': attendances?.map((e) => e.toJson()).toList(),
      'vouchers': vouchers?.map((e) => e.toJson()).toList(),
      'availableLeave': availableLeave,
      'usedLeave': usedLeave,
    };
  }

  // Converts DashboardModel to DashboardEntity
  DashboardEntity toEntity() {
    return DashboardEntity(
      activities: activities?.map((e) => e.toEntity()).toList(),
      availableLeave: availableLeave,
      usedLeave: usedLeave,
      leaves: leaves?.map((e) => e.toEntity()).toList(),
      attendances: attendances?.map((e) => e.toEntity()).toList(),
      vouchers: vouchers?.map((e) => e.toEntity()).toList(),
    );
  }

  // Converts DashboardEntity to DashboardModel
  static DashboardModel fromEntity(DashboardEntity entity) {
    return DashboardModel(
      activities: entity.activities?.map((e) => ActivityModel.fromEntity(e)).toList(),
      availableLeave: entity.availableLeave,
      usedLeave: entity.usedLeave,
      leaves: entity.leaves?.map((e) => LeaveModel.fromEntity(e)).toList(),
      attendances: entity.attendances?.map((e) => AttendanceModel.fromEntity(e)).toList(),
      vouchers: entity.vouchers?.map((e) => VoucherModel.fromEntity(e)).toList(),
    );
  }
}

class ActivityModel extends ActivityEntity {
  ActivityModel({
    int? activityId,
    int? activityPendingCount,
    String? activityPriority,
    String? activityStartDate,
    String? activityEndDate,
    String? estimateHours,
    String? activityStatus,
    String? title,
    String? project,
    String? createdAt,
    String? assignorName,
    String? assignorImage,
    String? projectName,
    List<AssignedUserModel>? assignedUsers,
  }) : super(
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
    assignedUsers: assignedUsers,
  );

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activityId: json['id'] as int?,
      activityPendingCount: json['pending_count'] as int?,
      activityPriority: json['priority'] as String?,
      activityStartDate: json['start_date'] as String?,
      activityEndDate: json['end_date'] as String?,
      estimateHours: json['estimate_hours'] as String?,
      activityStatus: json['status'] as String?,
      title: json['title'] as String?,
      project: json['project'] as String?,
      createdAt: json['created_at'] as String?,
      assignorName: json['assignor_name'] as String?,
      assignorImage: json['assignor_image'] as String?,
      projectName: json['project_name'] as String?,
      assignedUsers: (json['assigned_users'] as List?)
          ?.map((user) => AssignedUserModel.fromJson(user))
          .toList(),
    );
  }

  // Converts ActivityEntity to ActivityModel
  static ActivityModel fromEntity(ActivityEntity entity) {
    return ActivityModel(
      activityId: entity.activityId,
      activityPendingCount: entity.activityPendingCount,
      activityPriority: entity.activityPriority,
      activityStartDate: entity.activityStartDate,
      activityEndDate: entity.activityEndDate,
      estimateHours: entity.estimateHours,
      activityStatus: entity.activityStatus,
      title: entity.title,
      project: entity.project,
      createdAt: entity.createdAt,
      assignorName: entity.assignorName,
      assignorImage: entity.assignorImage,
      projectName: entity.projectName,
      assignedUsers: entity.assignedUsers?.map((e) => AssignedUserModel.fromEntity(e)).toList(),
    );
  }
}

class LeaveModel extends LeaveEntity {
  LeaveModel({
    int? leaveId,
    int? leaveUserid,
    String? leaveType,
    String? leaveStartDate,
    String? leaveEndDate,
    String? leaveStatus,
    String? leaveCreatedAt,
    String? leaveUpdatedAt,
    int? leaveDays,
    String? leaveReason,
    int? leaveResponsiblePersonId,
    int? leaveApproverId,
    String? leaveApproverName,
    String? leaveApproverImage
  }) : super(
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

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      leaveId: json['id'] as int?,
      leaveUserid: json['user_id'] as int?,
      leaveType: json['leave_type'] as String?,
      leaveStartDate: json['start_date'] as String?,
      leaveEndDate: json['end_date'] as String?,
      leaveStatus: json['status'] as String?,
      leaveCreatedAt: json['created_at'] as String?,
      leaveUpdatedAt: json['updated_at'] as String?,
      leaveDays: json['total_day'] as int?,
      leaveReason: json['reason'] as String?,
      leaveResponsiblePersonId: json['responsible_person_id'] as int?,
      leaveApproverId: json['approver_id'] as int?,
      leaveApproverName: json['approver_name'] as String?,
      leaveApproverImage: json['approver_image'] as String?,
    );
  }

  // Convert Entity to Model
  static LeaveModel fromEntity(LeaveEntity entity) {
    return LeaveModel(
      leaveId: entity.leaveId,
      leaveUserid: entity.leaveUserid,
      leaveType: entity.leaveType,
      leaveStartDate: entity.leaveStartDate,
      leaveEndDate: entity.leaveEndDate,
      leaveStatus: entity.leaveStatus,
      leaveCreatedAt: entity.leaveCreatedAt,
      leaveUpdatedAt: entity.leaveUpdatedAt,
      leaveDays: entity.leaveDays,
      leaveReason: entity.leaveReason,
      leaveResponsiblePersonId: entity.leaveResponsiblePersonId,
      leaveApproverId: entity.leaveApproverId,
      leaveApproverName: entity.leaveApproverName,
      leaveApproverImage: entity.leaveApproverImage,
    );
  }
}

class AttendanceModel extends AttendanceEntity {
  AttendanceModel({
    int? attendanceId,
    int? attendanceUserId,
    String? inTime,
    String? outTime,
    String? deviceIp,
    String? attendanceProject,
    String? attendanceCreatedAt,
    String? attendanceUpdatedAt,
    String? attendanceUserName,
  }) : super(
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

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attendanceId: json['id'] as int?,
      attendanceUserId: json['user_id'] as int?,
      inTime: json['in_time'] as String?,
      outTime: json['out_time'] as String?,
      deviceIp: json['device_ip'] as String?,
      attendanceProject: json['project'] as String?,
      attendanceCreatedAt: json['created_at'] as String?,
      attendanceUpdatedAt: json['updated_at'] as String?,
      attendanceUserName: json['user_name'] as String?,
    );
  }

  // Convert Entity to Model
  static AttendanceModel fromEntity(AttendanceEntity entity) {
    return AttendanceModel(
      attendanceId: entity.attendanceId,
      attendanceUserId: entity.attendanceUserId,
      inTime: entity.inTime,
      outTime: entity.outTime,
      deviceIp: entity.deviceIp,
      attendanceProject: entity.attendanceProject,
      attendanceCreatedAt: entity.attendanceCreatedAt,
      attendanceUpdatedAt: entity.attendanceUpdatedAt,
      attendanceUserName: entity.attendanceUserName,
    );
  }
}

class VoucherModel extends VoucherEntity {
  VoucherModel({
    int? voucherId,
    int? voucherUserId,
    String? voucherDate,
    String? voucherProject,
    int? costCenterId,
    String? payeeType,
    String? payeeOthersName,
    String? voucherCustomerId,
    String? voucherSupplierId,
    int? voucherPaidbyId,
    String? voucherDescription,
    String? totalAmount,
    String? voucherPurchaseId,
    String? voucherSaleId,
    int? voucherApproverId,
    String? voucherCreatedAt,
    String? voucherUpdatedAt,
    String? costCenterName,
    String? voucherCustomerName,
    String? voucherSupplierName,
    String? voucherPaidByName,
    String? voucherApproverName,
    String? voucherStatus,
  }) : super(
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

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      voucherId: json['id'] as int?,
      voucherUserId: json['user_id'] as int?,
      voucherDate: json['voucher_date'] as String?,
      voucherProject: json['project'] as String?,
      costCenterId: json['cost_center_id'] as int?,
      payeeType: json['payee_type'] as String?,
      payeeOthersName: json['payee_others_name'] as String?,
      voucherCustomerId: json['voucher_customer_id'] as String?,
      voucherSupplierId: json['voucher_supplier_id'] as String?,
      voucherPaidbyId: json['voucher_paidby_id'] as int?,
      voucherDescription: json['description'] as String?,
      totalAmount: json['total_amount'] as String?,
      voucherPurchaseId: json['purchase_id'] as String?,
      voucherSaleId: json['sale_id'] as String?,
      voucherApproverId: json['approver_id'] as int?,
      voucherCreatedAt: json['created_at'] as String?,
      voucherUpdatedAt: json['updated_at'] as String?,
      costCenterName: json['cost_center_name'] as String?,
      voucherCustomerName: json['voucher_customer_name'] as String?,
      voucherSupplierName: json['voucher_supplier_name'] as String?,
      voucherPaidByName: json['voucher_paid_by_name'] as String?,
      voucherApproverName: json['voucher_approver_name'] as String?,
      voucherStatus: json['status'] as String?,
    );
  }

  // Convert Entity to Model
  static VoucherModel fromEntity(VoucherEntity entity) {
    return VoucherModel(
      voucherId: entity.voucherId,
      voucherUserId: entity.voucherUserId,
      voucherDate: entity.voucherDate,
      voucherProject: entity.voucherProject,
      costCenterId: entity.costCenterId,
      payeeType: entity.payeeType,
      payeeOthersName: entity.payeeOthersName,
      voucherCustomerId: entity.voucherCustomerId,
      voucherSupplierId: entity.voucherSupplierId,
      voucherPaidbyId: entity.voucherPaidbyId,
      voucherDescription: entity.voucherDescription,
      totalAmount: entity.totalAmount,
      voucherPurchaseId: entity.voucherPurchaseId,
      voucherSaleId: entity.voucherSaleId,
      voucherApproverId: entity.voucherApproverId,
      voucherCreatedAt: entity.voucherCreatedAt,
      voucherUpdatedAt: entity.voucherUpdatedAt,
      costCenterName: entity.costCenterName,
      voucherCustomerName: entity.voucherCustomerName,
      voucherSupplierName: entity.voucherSupplierName,
      voucherPaidByName: entity.voucherPaidByName,
      voucherApproverName: entity.voucherApproverName,
      voucherStatus: entity.voucherStatus,
    );
  }
}

class AssignedUserModel extends AssignedUserEntity {
  const AssignedUserModel({
    required int id,
    required String name,
    String? profilePhotoPath,
  }) : super(
          id: id,
          name: name,
          profilePhotoPath: profilePhotoPath,
        );

  // Create Model from JSON
  factory AssignedUserModel.fromJson(Map<String, dynamic> json) {
    return AssignedUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      profilePhotoPath: json['profile_photo_path'] as String?,
    );
  }

  // Create Model from Entity
  factory AssignedUserModel.fromEntity(AssignedUserEntity entity) {
    return AssignedUserModel(
      id: entity.id,
      name: entity.name,
      profilePhotoPath: entity.profilePhotoPath,
    );
  }
}

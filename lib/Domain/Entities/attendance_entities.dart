class AttendanceRequest {
  final int? id;
  final int? userId;
  final String? inTime;
  final String? projectId;
  final String? projectName;
  final String? description;
  final int? supervisorUserId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final User? user;

  AttendanceRequest({
    required this.id,
    required this.userId,
    required this.inTime,
    required this.projectId,
    required this.projectName,
    required this.description,
    required this.supervisorUserId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? department;
  final String? designation;
  final String? employeeId;
  final double? balance;
  final double? openingBalance;
  final String? openingBalanceDate;
  final String? emailVerifiedAt;
  final String? twoFactorConfirmedAt;
  final int? currentTeamId;
  final String? profilePhotoPath;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? profilePhotoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.designation,
    required this.employeeId,
    required this.balance,
    required this.openingBalance,
    required this.openingBalanceDate,
    this.emailVerifiedAt,
    this.twoFactorConfirmedAt,
    required this.currentTeamId,
    this.profilePhotoPath,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.profilePhotoUrl,
  });
}


import '../../Domain/Entities/attendance_entities.dart';

class AttendanceRequestModel extends AttendanceRequest {
  AttendanceRequestModel({
    required int? id,
    required int? userId,
    required String? inTime,
    required String? projectId,
    required String? projectName,
    required String? description,
    required int? supervisorUserId,
    required String? status,
    required String? createdAt,
    required String? updatedAt,
    UserModel? user,
  }) : super(
    id: id,
    userId: userId,
    inTime: inTime,
    projectId: projectId,
    projectName: projectName,
    description: description,
    supervisorUserId: supervisorUserId,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
    user: user,
  );

  factory AttendanceRequestModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRequestModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      inTime: json['in_time'] ?? '',
      projectId: json['cost_center_id'] ?? '',
      projectName: json['cost_center_name'] ?? '',
      description: json['description'] ?? '',
      supervisorUserId: json['supervisor_user_id'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'in_time': inTime,
      'cost_center_id': projectId,
      'cost_center_name': projectName,
      'description': description,
      'supervisor_user_id': supervisorUserId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': (user as UserModel?)?.toJson(),
    };
  }
}

class UserModel extends User {
  UserModel({
    required int id,
    required String name,
    required String email,
    required String phone,
    required String department,
    required String designation,
    required String employeeId,
    required double balance,
    required double openingBalance,
    required String openingBalanceDate,
    String? emailVerifiedAt,
    String? twoFactorConfirmedAt,
    required int currentTeamId,
    String? profilePhotoPath,
    required String status,
    required String createdAt,
    required String updatedAt,
    required String profilePhotoUrl,
  }) : super(
    id: id,
    name: name,
    email: email,
    phone: phone,
    department: department,
    designation: designation,
    employeeId: employeeId,
    balance: balance,
    openingBalance: openingBalance,
    openingBalanceDate: openingBalanceDate,
    emailVerifiedAt: emailVerifiedAt,
    twoFactorConfirmedAt: twoFactorConfirmedAt,
    currentTeamId: currentTeamId,
    profilePhotoPath: profilePhotoPath,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
    profilePhotoUrl: profilePhotoUrl,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      employeeId: json['employee_id'] ?? 0,
      balance: (json['balance'] as num).toDouble() ?? 0.0,
      openingBalance: (json['opening_balance'] as num).toDouble() ?? 0.0,
      openingBalanceDate: json['opening_balance_date'] ?? '',
      emailVerifiedAt: json['email_verified_at'] ?? '',
      twoFactorConfirmedAt: json['two_factor_confirmed_at'] ?? '',
      currentTeamId: json['current_team_id'] ?? '',
      profilePhotoPath: json['profile_photo_path'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      profilePhotoUrl: json['profile_photo_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'designation': designation,
      'employee_id': employeeId,
      'balance': balance,
      'opening_balance': openingBalance,
      'opening_balance_date': openingBalanceDate,
      'email_verified_at': emailVerifiedAt,
      'two_factor_confirmed_at': twoFactorConfirmedAt,
      'current_team_id': currentTeamId,
      'profile_photo_path': profilePhotoPath,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}


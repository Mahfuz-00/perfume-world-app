import '../../Domain/Entities/activity_entities.dart';

class ActivityModel extends ActivityEntity {

  ActivityModel({
    int? id,
    String? title,
    String? projectId,
    String? projectName,
    String? startDate,
    String? endDate,
    String? estimateHours,
    int? assignor,
   /* String? assignorId,*/
    String? description,
    String? comment,
    String? priority,
    String? status,
    DateTime? updatedAt,
    List<AssignedUserModel>? assignedUsers,
  }) : super(
    id: id,
    title: title,
    projectId: projectId,
    projectName: projectName,
    startDate: startDate,
    endDate: endDate,
    estimateHours: estimateHours,
    assignor: assignor,
    description: description,
    comment: comment,
    priority: priority,
    status: status,
    updatedAt: updatedAt,
    assignedUsers: assignedUsers?.map((user) => user.toEntity()).toList(),
  );

  factory ActivityModel.fromEntity(ActivityEntity entity) {
    return ActivityModel(
      id: entity.id,
      title: entity.title,
      projectId: entity.projectId,
      projectName: entity.projectName,
      startDate: entity.startDate,
      endDate: entity.endDate,
      estimateHours: entity.estimateHours,
      assignor: entity.assignor,
   /*   assignorId: entity.assignor != null ? entity.assignor.toString() : null,  */// Assuming assignorId as a String representation of assignor
      description: entity.description,
      comment: entity.comment,
      priority: entity.priority,
      status: entity.status,
      updatedAt: entity.updatedAt,
      assignedUsers: entity.assignedUsers
          ?.map((assignedUserEntity) => AssignedUserModel.fromEntity(assignedUserEntity))
          .toList(),
    );
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      projectId: json['project'] ?? '',
      projectName: json['project_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      estimateHours: json['estimate_hours'] ?? '',
      assignor: json['assignor'] ?? 0,
      description: json['description'] ?? '',
      comment: json['comment'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      updatedAt: DateTime.parse(json['updated_at']) ?? DateTime(1970),
      assignedUsers: (json['assigned_users'] as List?)
          ?.map((user) => AssignedUserModel.fromJson(user))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'project': projectId,
      'project_name': projectName,
      'start_date': startDate,
      'end_date': endDate,
      'estimate_hours': estimateHours,
      'assignor': assignor,
      'description': description,
      'comment': comment,
      'priority': priority,
      'status': status,
      'updated_at': updatedAt?.toIso8601String(),
      'assigned_users': assignedUsers?.map((user) => user.toJson()).toList(),
    };
  }

  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id,
      title: title,
      projectId: projectId,
      projectName: projectName,
      startDate: startDate,
      endDate: endDate,
      estimateHours: estimateHours,
      assignor: assignor,
      description: description,
      comment: comment,
      priority: priority,
      status: status,
      updatedAt: updatedAt,
      assignedUsers: assignedUsers?.map((user) => user.toEntity()).toList(),
    );
  }
}

// AssignedUserModel (extends AssignedUserEntity)
class AssignedUserModel extends AssignedUserEntity {
  AssignedUserModel({
    int? id,
    String? name,
    String? profilePhotoPath,
  }) : super(
    id: id,
    name: name,
    profilePhotoPath: profilePhotoPath,
  );

  factory AssignedUserModel.fromJson(Map<String, dynamic> json) {
    return AssignedUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePhotoPath: json['profile_photo_path'] ?? '',
    );
  }

  factory AssignedUserModel.fromEntity(AssignedUserEntity entity) {
    return AssignedUserModel(
      id: entity.id,
      name: entity.name,
      profilePhotoPath: entity.profilePhotoPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_photo_path': profilePhotoPath,
    };
  }

  AssignedUserEntity toEntity() {
    return AssignedUserEntity(
      id: id,
      name: name,
      profilePhotoPath: profilePhotoPath,
    );
  }
}

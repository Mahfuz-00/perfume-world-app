class ActivityEntity {
  final int? id;
  final String? title;
  final String? projectId;
  final String? projectName;
  final String? startDate;
  final String? endDate;
  final String? estimateHours;
  final int? assignor;
  final String? description;
  final String? comment;
  final String? priority;
  final String? status;
  final DateTime? updatedAt;
  final List<AssignedUserEntity>? assignedUsers;

  ActivityEntity({
    this.id,
    this.title,
    this.projectId,
    this.projectName,
    this.startDate,
    this.endDate,
    this.estimateHours,
    this.assignor,
    this.description,
    this.comment,
    this.priority,
    this.status,
    this.updatedAt,
    this.assignedUsers,
  });

  factory ActivityEntity.fromJson(Map<String, dynamic> json) {
    return ActivityEntity(
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
          ?.map((user) => AssignedUserEntity.fromJson(user))
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
      'status': status,
      'updated_at': updatedAt?.toIso8601String(),
      'assigned_users': assignedUsers?.map((user) => user.toJson()).toList(),
    };
  }
}

// AssignedUserEntity
class AssignedUserEntity {
  final int? id;
  final String? name;
  final String? profilePhotoPath;

  AssignedUserEntity({
    this.id,
    this.name,
    this.profilePhotoPath,
  });

  factory AssignedUserEntity.fromJson(Map<String, dynamic> json) {
    return AssignedUserEntity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePhotoPath: json['profile_photo_path'] ?? '',
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

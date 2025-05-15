class ProfileModel {
  final dynamic name;
  final dynamic designation;
  final dynamic photoUrl;
  final dynamic email;
  final dynamic phoneNumber;
  final dynamic employeeID;
  final dynamic department;

  ProfileModel({
    required this.name,
    required this.designation,
    required this.photoUrl,
    required this.email,
    required this.phoneNumber,
    required this.employeeID,
    required this.department,
  });

  // ToJson method for encoding
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'photoUrl': photoUrl,
      'email': email,
      'phone': phoneNumber,
      'employee_id': employeeID,
      'department': department,
    };
  }

  // FromJson method for decoding
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] as String?,
      designation: json['designation'] as String?,
      photoUrl: json['profile_photo_url'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone'] as String?,
      employeeID: json['employee_id'] as String?,
      department: json['department'] as String?,
    );
  }
}

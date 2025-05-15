import '../../Data/Models/profile.dart';

class ProfileEntity {
  final dynamic name;
  final dynamic designation;
  final dynamic photoUrl;
  final dynamic email;
  final dynamic phoneNumber;
  final dynamic employeeID;
  final dynamic department;

  ProfileEntity({
    required this.name,
    required this.designation,
    required this.photoUrl,
    required this.email,
    required this.phoneNumber,
    required this.employeeID,
    required this.department,
  });

  // ToEntities method for converting from Model to Entity
  static ProfileEntity fromModel(ProfileModel profile) {
    return ProfileEntity(
      name: profile.name,
      designation: profile.designation,
      photoUrl: profile.photoUrl,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      employeeID: profile.employeeID,
      department: profile.department,
    );
  }
}

import '../../Domain/Entities/project_entities.dart';

class ProjectModel extends ProjectEntity {
  final int id;
  final String name;

  // Constructor
  ProjectModel({required this.id, required this.name})
      : super(id: id, name: name); // Call the super constructor of the parent class

  // Convert from JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  // Convert to Entity (Project) - This can now return a Project since it's extended
  @override
  ProjectEntity toEntity() {
    return ProjectEntity(id: id, name: name);
  }
}

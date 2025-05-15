class ActivityFormModel {
  final String title;
  final String project;
  final String startDate;
  final String endDate;
  final int estimatedHour;
 /* final String assignedEmployee;*/
  final String description;
  final String priority;
  final String status;

  ActivityFormModel({
    required this.title,
    required this.project,
    required this.startDate,
    required this.endDate,
    required this.estimatedHour,
  /*  required this.assignedEmployee,*/
    required this.description,
    required this.priority,
    required this.status,
  });

  // Convert ActivityModel to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'actvTitle': title,
      'actvProject': project,
      'actvStartDate': startDate,
      'actvEndDate': endDate,
      'actvEstimatedHour': estimatedHour,
     /* 'actvProjectUser': assignedEmployee,*/
      'actvDescription': description,
      'priority': priority,
      'status': status,
    };
  }
}

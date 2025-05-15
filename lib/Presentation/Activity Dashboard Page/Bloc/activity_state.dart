import '../../../Domain/Entities/activity_entities.dart';

class ActivityState {
  final List<ActivityEntity> tasks;
  final bool isLoading;
  final String errorMessage;

  ActivityState({
    required this.tasks,
    required this.isLoading,
    this.errorMessage = '',
  });

  // Method to copy and modify the state (to avoid direct modification)
  ActivityState copyWith({
    List<ActivityEntity>? tasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ActivityState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Initial state before any tasks are loaded
class ActivityInitialState extends ActivityState {
  ActivityInitialState() : super(tasks: [], isLoading: false, errorMessage: '');
}

// State when tasks are being loaded
class ActivityLoadingState extends ActivityState {
  ActivityLoadingState() : super(tasks: [], isLoading: true, errorMessage: '');
}

// State when tasks are successfully loaded
class ActivityLoadedState extends ActivityState {
  final Map<String, int> taskCounts; // Store task counts for each section

  ActivityLoadedState(List<ActivityEntity> tasks, this.taskCounts)
      : super(tasks: tasks, isLoading: false, errorMessage: '');
}


// State when there is an error while loading tasks
class ActivityErrorState extends ActivityState {
  ActivityErrorState(String errorMessage)
      : super(tasks: [], isLoading: false, errorMessage: errorMessage);
}

class ActivitySectionCountsState extends ActivityState {
  final Map<String, int> sectionCounts;
  ActivitySectionCountsState(this.sectionCounts) : super(tasks: [], isLoading: false, errorMessage: '');
}

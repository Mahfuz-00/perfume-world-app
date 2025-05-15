import 'package:bloc/bloc.dart';
import '../../../Domain/Entities/activity_entities.dart';
import '../../../Domain/Usecases/activity_usecases.dart';
import 'activity_event.dart';
import 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityUseCase useCase;

  ActivityBloc(this.useCase) : super(ActivityInitialState()) {
    on<LoadActivityEvent>(_onLoadTasksEvent);
  }

  // Event handler method
  Future<void> _onLoadTasksEvent(
      LoadActivityEvent event,
      Emitter<ActivityState> emit,
      ) async {
    emit(ActivityLoadingState());
    try {
      print("Loading tasks...");
      final tasks = await useCase.execute();

      // Calculate task counts
      final taskCounts = _calculateTaskCounts(tasks);

      // Emit the loaded state with tasks and task counts
      emit(ActivityLoadedState(tasks, taskCounts));
    } catch (error) {
      print("Error loading tasks: $error");
      emit(ActivityErrorState(error.toString()));
    }
  }

  // Helper method to calculate task counts
  Map<String, int> _calculateTaskCounts(List<ActivityEntity> tasks) {
    final taskCounts = {
      'All': tasks.length,
      'To Do': tasks.where((task) => task.status == 'To Do' || task.status == 'Pending'|| task.status == 'pending').length,
      'In Progress': tasks.where((task) => task.status == 'In Progress'|| task.status == 'in_progress').length,
      'Finished': tasks.where((task) => task.status == 'Complete' || task.status == 'Finished'|| task.status == 'complete').length,
    };
    return taskCounts;
  }
}

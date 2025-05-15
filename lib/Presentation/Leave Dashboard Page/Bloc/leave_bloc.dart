import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Domain/Entities/leave_entities.dart';
import '../../../Domain/Usecases/leave_usecase.dart';

part 'leave_event.dart';
part 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final GetLeaveUseCase getLeaveApplicationsUseCase;

  LeaveBloc({required this.getLeaveApplicationsUseCase}) : super(LeaveApplicationInitial()) {
    on<LoadLeaveApplications>((event, emit) async {
      emit(LeaveApplicationLoading());
      try {
        final leaveApplications = await getLeaveApplicationsUseCase();
        emit(LeaveApplicationLoaded(leaveApplications: leaveApplications));
      } catch (e) {
        emit(LeaveApplicationError(message: e.toString()));
      }
    });
  }
}

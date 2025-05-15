import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Domain/Entities/attendance_entities.dart';
import '../../../Domain/Usecases/attendance_usecase.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceRequestsUseCase getAttendanceRequestsUseCase;

  AttendanceBloc({required this.getAttendanceRequestsUseCase}) : super(AttendanceInitial()) {
    on<FetchAttendanceRequestsEvent>((event, emit) async {
      emit(AttendanceLoading());
      try {
        final attendanceRequests = await getAttendanceRequestsUseCase();
        emit(AttendanceLoaded(attendanceRequests));
      } catch (e) {
        emit(AttendanceError(e.toString()));
      }
    });
  }
}


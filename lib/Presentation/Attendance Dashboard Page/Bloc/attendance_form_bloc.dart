import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Data/Models/attendance_form.dart';
import '../../../Domain/Entities/attendance_form_entities.dart';
import '../../../Domain/Usecases/attendance_form_usecase.dart';

part 'attendance_form_event.dart';

part 'attendance_form_state.dart';

class AttendanceFormBloc extends Bloc<AttendanceFormEvent, AttendanceFormState> {
  final AttendanceFormUseCase _attendanceFormUseCase;

  AttendanceFormBloc({required AttendanceFormUseCase attendanceFormUseCase})
      : _attendanceFormUseCase = attendanceFormUseCase,
        super(AttendanceInitial()) {
    on<CreateAttendanceEvent>(_onCreateAttendanceEvent);
  }

  Future<void> _onCreateAttendanceEvent(
      CreateAttendanceEvent event,
      Emitter<AttendanceFormState> emit,
      ) async {
    try {
      final result = await _attendanceFormUseCase.createAttendance(event.attendanceForm);
      emit(AttendanceSubmitted());
    } catch (error) {
      print("Error occurred: $error");
      emit(AttendanceFormFailure(error: error.toString()));
    }
  }
}

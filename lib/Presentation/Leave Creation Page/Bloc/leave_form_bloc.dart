import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Domain/Entities/leave_form_entities.dart';
import '../../../Domain/Usecases/leave_form_usecase.dart';

part 'leave_form_event.dart';

part 'leave_form_state.dart';

class LeaveFormBloc extends Bloc<LeaveFormEvent, LeaveFormState> {
  final SubmitLeaveFormUseCase submitLeaveFormUseCase;

  LeaveFormBloc({required this.submitLeaveFormUseCase})
      : super(LeaveFormInitial()) {
    on<SubmitLeaveFormEvent>(_onSubmitLeaveFormEvent);
  }

  Future<void> _onSubmitLeaveFormEvent(
    SubmitLeaveFormEvent event,
    Emitter<LeaveFormState> emit,
  ) async {
    emit(LeaveFormLoading());

    try {
      await submitLeaveFormUseCase(event.leaveForm);
      emit(LeaveFormSuccess());
    } catch (e) {
      emit(LeaveFormFailure(e.toString()));
    }
  }
}

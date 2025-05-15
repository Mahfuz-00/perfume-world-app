import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Domain/Entities/activity_form_entities.dart';
import '../../../Domain/Usecases/activity_form_usercase.dart';


part 'activity_form_event.dart';
part 'activity_form_state.dart';

class ActivityFormBloc extends Bloc<ActivityFormEvent, ActivityFormState> {
  final ActivityFormUseCase createActivityUseCase;

  ActivityFormBloc(this.createActivityUseCase) : super(ActivityFormInitial()) {
    on<SubmitActivityEvent>(_onSubmitActivityEvent);
  }

  Future<void> _onSubmitActivityEvent(
      SubmitActivityEvent event, Emitter<ActivityFormState> emit) async {
    print('SubmitActivityEvent received 11');
    emit(ActivityFormLoading());
    try {
      print('SubmitActivityEvent received 31');
      await createActivityUseCase(event.activity);
      print('SubmitActivityEvent received 21');
      emit(ActivityFormSuccess());
      print('State changed to ActivityFormSuccess');
    } catch (error) {
      print('Bloc Error: $error');
      emit(ActivityFormFailure(error.toString()));
    }
  }
}


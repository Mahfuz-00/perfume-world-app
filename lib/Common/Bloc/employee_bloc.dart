import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Domain/Entities/employee_entities.dart';
import '../../../Domain/Usecases/employee_usecase.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployeesUseCase getEmployeesUseCase;

  EmployeeBloc({required this.getEmployeesUseCase}) : super(EmployeeInitial()) {
    on<FetchEmployeesEvent>((event, emit) async {
      emit(EmployeeLoading());
      try {
        final employees = await getEmployeesUseCase();
        emit(EmployeeLoaded(employees: employees));
      } catch (e) {
        emit(EmployeeError(error: e.toString()));
      }
    });
  }
}


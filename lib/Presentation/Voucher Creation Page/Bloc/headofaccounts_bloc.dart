import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Domain/Entities/head_of_accounts_entities.dart';
import '../../../Domain/Usecases/head_of_accounts_usecase.dart';

part 'headofaccounts_event.dart';
part 'headofaccounts_state.dart';

class ExpenseHeadBloc extends Bloc<ExpenseHeadEvent, ExpenseHeadState> {
  final GetExpenseHeadsUseCase getExpenseHeadsUseCase;

  ExpenseHeadBloc(this.getExpenseHeadsUseCase) : super(ExpenseHeadInitial()) {
    on<FetchExpenseHeadsEvent>((event, emit) async {
      emit(ExpenseHeadLoading());
      try {
        final expenseHeads = await getExpenseHeadsUseCase();
        emit(ExpenseHeadLoaded(expenseHeads: expenseHeads));
      } catch (e) {
        emit(ExpenseHeadError(error: e.toString()));
      }
    });
  }
}

import '../Entities/head_of_accounts_entities.dart';
import '../Repositories/head_of_accounts_repositories.dart';


class GetExpenseHeadsUseCase {
  final ExpenseHeadRepository repository;

  GetExpenseHeadsUseCase(this.repository);

  Future<List<ExpenseHeadEntity>> call() async {
    return await repository.fetchExpenseHeads();
  }
}

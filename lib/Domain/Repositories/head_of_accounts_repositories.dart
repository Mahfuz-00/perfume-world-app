import '../Entities/head_of_accounts_entities.dart';

abstract class ExpenseHeadRepository {
  Future<List<ExpenseHeadEntity>> fetchExpenseHeads();
}

import '../../Domain/Entities/head_of_accounts_entities.dart';

class ExpenseHeadModel extends ExpenseHeadEntity {
  const ExpenseHeadModel({required String id, required String name})
      : super(id: id, name: name);

  // Convert JSON to model
  factory ExpenseHeadModel.fromJson(Map<String, dynamic> json) {
    return ExpenseHeadModel(
      id: json['id'].toString(), // Convert int ID to String
      name: json['name'] as String,
    );
  }

  // Convert model to entity
  ExpenseHeadEntity toEntity() {
    return ExpenseHeadEntity(
      id: id,
      name: name,
    );
  }
}

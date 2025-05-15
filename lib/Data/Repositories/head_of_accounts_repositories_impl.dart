import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Domain/Entities/head_of_accounts_entities.dart';
import '../../Domain/Repositories/head_of_accounts_repositories.dart';
import '../Models/head_of_accounts.dart';
import '../Sources/head_of_accounts_remote_source.dart';

class ExpenseHeadRepositoryImpl implements ExpenseHeadRepository {
  final ExpenseHeadRemoteDataSource remoteDataSource;

  ExpenseHeadRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ExpenseHeadEntity>> fetchExpenseHeads() async {
    try {
      // Fetch data from the remote data source
      final models = await remoteDataSource.fetchExpenseHeads();

      // Convert the fetched list of maps to ExpenseHead entities
      return models
          .map(
            (model) => ExpenseHeadModel.fromJson(model).toEntity(),
      )
          .toList();
    } catch (e) {
      // Handle any errors
      throw Exception('Failed to fetch expense heads: $e');
    }
  }
}

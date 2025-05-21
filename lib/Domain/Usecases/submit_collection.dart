import 'package:perfume_world_app/Domain/Entities/Collection_entities.dart';
import '../Repositories/invoice_repositories.dart';

class SubmitCollection {
  final InvoiceRepository repository;

  SubmitCollection(this.repository);

  Future<String> call(Collection collection) async {
    return await repository.submitCollection(collection);
  }
}
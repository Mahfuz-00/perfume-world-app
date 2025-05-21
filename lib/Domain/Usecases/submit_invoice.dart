import '../Entities/invoice_entities.dart';
import '../Repositories/invoice_repositories.dart';

class SubmitInvoice {
  final InvoiceRepository repository;

  SubmitInvoice(this.repository);

  Future<String> call(Invoice invoice) async {
    return await repository.submitInvoice(invoice);
  }
}
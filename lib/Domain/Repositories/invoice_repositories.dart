import 'package:perfume_world_app/Domain/Entities/Collection_entities.dart';
import '../Entities/invoice_entities.dart';

abstract class InvoiceRepository {
  Future<String> submitInvoice(Invoice invoice);
  Future<String> submitCollection(Collection collection);
}
import 'package:perfume_world_app/Domain/Entities/Collection_entities.dart';
import '../../Domain/Entities/invoice_entities.dart';
import '../../Domain/Repositories/invoice_repositories.dart';
import '../Models/Collection.dart';
import '../Models/invoice.dart';
import '../Sources/invoice_remote_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> submitInvoice(Invoice invoice) async {
    try {
      final invoiceModel = InvoiceModel(
        invoiceNo: invoice.invoiceNo,
        type: invoice.type,
        vat: invoice.vat,
        items: invoice.items?.map((item) => InvoiceItemModel(
          customerId: item.customerId,
          productId: item.productId,
          productName: item.productName,
          quantity: item.quantity,
          serials: item.serials,
          price: item.price,
          discount: item.discount,
          invDiscount: item.invDiscount,
          address: item.address,
          description: item.description,
          termsAndConditions: item.termsAndConditions,
          totalPrice: item.totalPrice,
          costUnitPrice: item.costUnitPrice,
        )).toList(),
      );
      return await remoteDataSource.submitInvoice(invoiceModel);
    } catch (e) {
      throw Exception('Failed to submit invoice: $e');
    }
  }

  @override
  Future<String> submitCollection(Collection collection) async {
    try {
      final collectionModel = CollectionModel(
        customerId: collection.customerId,
        prevDues: collection.prevDues,
        invoiceNo: collection.invoiceNo,
        cashmemoNo: collection.cashmemoNo,
        collectionDate: collection.collectionDate,
        paymentMethod: collection.paymentMethod,
        collectedAmount: collection.collectedAmount,
      );
      return await remoteDataSource.submitCollection(collectionModel);
    } catch (e) {
      throw Exception('Failed to submit collection: $e');
    }
  }
}
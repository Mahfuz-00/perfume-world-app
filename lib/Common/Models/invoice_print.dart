import 'package:intl/intl.dart';
import 'package:perfume_world_app/Common/Models/cart_model.dart';
import 'package:perfume_world_app/Domain/Entities/customer_entities.dart';

class InvoicePrintState {
  final Customer? customer;
  final double totalPrice;
  final String invoiceNumber;
  final List<CartItem> cartItems;
  final String? paymentMethod;
  final String? collectedAmount;
  final String? checkNo;
  final DateTime? checkDate;
  final String? refNo;
  final String? remark;
  final String? cashMemoNo;
  final Map<CartItem, double> itemDiscounts;
  final String vat;
  final String invoiceDiscount;
  final String shipping;

  InvoicePrintState({
    this.customer,
    required this.totalPrice,
    required this.invoiceNumber,
    required this.cartItems,
    this.paymentMethod,
    this.collectedAmount,
    this.checkNo,
    this.checkDate,
    this.refNo,
    this.remark,
    this.cashMemoNo,
    required this.itemDiscounts,
    required this.vat,
    required this.invoiceDiscount,
    required this.shipping,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customer?.id.toString(),
      'customerName': customer?.name ?? 'No customer selected',
      'customerPhone': customer?.phone ?? '',
      'previousDue': customer?.previousDue.toString() ?? '0',
      'totalPrice': totalPrice.toStringAsFixed(2),
      'invoiceNumber': invoiceNumber,
      'cartItems': cartItems
          .map((item) => {
        'productId': item.product.id,
        'productName': item.product.name,
        'productCode': item.product.code,
        'price': item.product.price,
        'quantity': item.quantity.toString(),
        'discount': itemDiscounts[item]?.toString() ?? '0',
        'total': ((double.tryParse(item.product.price) ?? 0) * item.quantity - (itemDiscounts[item] ?? 0)).toStringAsFixed(2),
      })
          .toList(),
      'paymentMethod': paymentMethod,
      'collectedAmount': collectedAmount,
      'checkNo': checkNo,
      'checkDate': checkDate != null ? DateFormat('MM/dd/yyyy').format(checkDate!) : null,
      'refNo': refNo,
      'remark': remark,
      'cashMemoNo': cashMemoNo,
      'vat': vat,
      'invoiceDiscount': invoiceDiscount,
      'shipping': shipping,
    };
  }
}
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../Common/Models/cart_model.dart';
import '../../../Domain/Entities/customer_entities.dart';

class InvoicePrintState extends Equatable {
  final Customer? customer;
  final double totalPrice;
  final String invoiceNumber;
  final List<CartItem> cartItems;
  final Map<CartItem, double> itemDiscounts;
  final String vat;
  final String invoiceDiscount;
  final String shipping;
  final String? paymentMethod;
  final String? collectedAmount;
  final String? checkNo;
  final DateTime? checkDate;
  final String? refNo;
  final String? remark;
  final String? cashMemoNo;
  final String? imagePath;

  InvoicePrintState({
    this.customer,
    this.totalPrice = 0.0,
    this.invoiceNumber = '',
    this.cartItems = const [],
    this.itemDiscounts = const {},
    this.vat = '0',
    this.invoiceDiscount = '0',
    this.shipping = '0',
    this.paymentMethod,
    this.collectedAmount,
    this.checkNo,
    this.checkDate,
    this.refNo,
    this.remark,
    this.cashMemoNo,
    this.imagePath = 'Assets/Images/TNS Logo 4X.png',
  });

  InvoicePrintState copyWith({
    Customer? customer,
    double? totalPrice,
    String? invoiceNumber,
    List<CartItem>? cartItems,
    Map<CartItem, double>? itemDiscounts,
    String? vat,
    String? invoiceDiscount,
    String? shipping,
    String? paymentMethod,
    String? collectedAmount,
    String? checkNo,
    DateTime? checkDate,
    String? refNo,
    String? remark,
    String? cashMemoNo,
    String? imagePath,
  }) {
    return InvoicePrintState(
      customer: customer ?? this.customer,
      totalPrice: totalPrice ?? this.totalPrice,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      cartItems: cartItems ?? this.cartItems,
      itemDiscounts: itemDiscounts ?? this.itemDiscounts,
      vat: vat ?? this.vat,
      invoiceDiscount: invoiceDiscount ?? this.invoiceDiscount,
      shipping: shipping ?? this.shipping,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      collectedAmount: collectedAmount ?? this.collectedAmount,
      checkNo: checkNo ?? this.checkNo,
      checkDate: checkDate ?? this.checkDate,
      refNo: refNo ?? this.refNo,
      remark: remark ?? this.remark,
      cashMemoNo: cashMemoNo ?? this.cashMemoNo,
      imagePath: imagePath ?? this.imagePath,
    );
  }

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
      'imagePath': imagePath,
    };
  }

  @override
  List<Object?> get props => [
    customer,
    totalPrice,
    invoiceNumber,
    cartItems,
    itemDiscounts,
    vat,
    invoiceDiscount,
    shipping,
    paymentMethod,
    collectedAmount,
    checkNo,
    checkDate,
    refNo,
    remark,
    cashMemoNo,
    imagePath,
  ];
}
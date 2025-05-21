import '../../Domain/Entities/invoice_entities.dart';

class InvoiceModel extends Invoice {
  InvoiceModel({
    String? invoiceNo,
    String? type,
    String? vat,
    List<InvoiceItemModel>? items,
  }) : super(invoiceNo: invoiceNo, type: type, vat: vat, items: items);

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceNo: json['invoice_no'] as String?,
      type: json['type'] as String?,
      vat: json['vat'] as String?,
      items: (json['data'] as List<dynamic>?)?.map((e) => InvoiceItemModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_no': invoiceNo,
      'type': type,
      'vat': vat,
      'data': items?.map((e) => (e as InvoiceItemModel).toJson()).toList(),
    };
  }
}

class InvoiceItemModel extends InvoiceItem {
  InvoiceItemModel({
    String? customerId,
    int? productId,
    String? productName,
    String? quantity,
    String? serials,
    String? price,
    String? discount,
    String? invDiscount,
    String? address,
    String? description,
    String? termsAndConditions,
    String? totalPrice,
    String? costUnitPrice,
  }) : super(
    customerId: customerId,
    productId: productId,
    productName: productName,
    quantity: quantity,
    serials: serials,
    price: price,
    discount: discount,
    invDiscount: invDiscount,
    address: address,
    description: description,
    termsAndConditions: termsAndConditions,
    totalPrice: totalPrice,
    costUnitPrice: costUnitPrice,
  );

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      customerId: json['customer_id'] as String?,
      productId: json['product_id'] as int?,
      productName: json['product_name'] as String?,
      quantity: json['quantity'] as String?,
      serials: json['serials'] as String?,
      price: json['price'] as String?,
      discount: json['discount'] as String?,
      invDiscount: json['inv_discount'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      termsAndConditions: json['tarms_and_conditions'] as String?,
      totalPrice: json['totalPrice'] as String?,
      costUnitPrice: json['cost_unit_price'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'serials': serials,
      'price': price,
      'discount': discount,
      'inv_discount': invDiscount,
      'address': address,
      'description': description,
      'tarms_and_conditions': termsAndConditions,
      'totalPrice': totalPrice,
      'cost_unit_price': costUnitPrice,
    };
  }
}
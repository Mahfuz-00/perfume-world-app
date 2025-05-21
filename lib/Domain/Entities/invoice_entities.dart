class Invoice {
  final String? invoiceNo;
  final String? type;
  final String? vat;
  final List<InvoiceItem>? items;

  Invoice({this.invoiceNo, this.type, this.vat, this.items});

  Map<String, dynamic> toJson() {
    return {
      'invoice_no': invoiceNo,
      'type': type,
      'vat': vat,
      'data': items?.map((item) => item.toJson()).toList(),
    };
  }
}

class InvoiceItem {
  final String? customerId;
  final int? productId;
  final String? productName;
  final String? quantity;
  final String? serials;
  final String? price;
  final String? discount;
  final String? invDiscount;
  final String? address;
  final String? description;
  final String? termsAndConditions;
  final String? totalPrice;
  final String? costUnitPrice;

  InvoiceItem({
    this.customerId,
    this.productId,
    this.productName,
    this.quantity,
    this.serials,
    this.price,
    this.discount,
    this.invDiscount,
    this.address,
    this.description,
    this.termsAndConditions,
    this.totalPrice,
    this.costUnitPrice,
  });

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
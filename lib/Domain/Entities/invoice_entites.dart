class Invoice {
  final String? invoiceNo;
  final String? type;
  final String? vat;
  final List<InvoiceItem>? items;

  Invoice({this.invoiceNo, this.type, this.vat, this.items});
}

class InvoiceItem {
  final String? customerId;
  final String? productId;
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
}
class Collection {
  final String? customerId;
  final String? prevDues;
  final String? invoiceNo;
  final String? cashmemoNo;
  final String? collectionDate;
  final String? paymentMethod;
  final String? collectedAmount;

  Collection({
    this.customerId,
    this.prevDues,
    this.invoiceNo,
    this.cashmemoNo,
    this.collectionDate,
    this.paymentMethod,
    this.collectedAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'prev_dues': prevDues,
      'invoice_no': invoiceNo,
      'cashmemo_no': cashmemoNo,
      'collection_date': collectionDate,
      'payment_method': paymentMethod,
      'collected_ammount': collectedAmount,
    };
  }
}
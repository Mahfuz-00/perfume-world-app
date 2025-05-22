class Collection {
  final String? customerId;
  final String? prevDues;
  final String? invoiceNo;
  final String? cashmemoNo;
  final String? collectionDate;
  final String? paymentMethod;
  final String? collectedAmount;
  final String? invoiceCollected;
  final String? invoiceDue;
  final String? chequeNo;
  final String? chequeDate;
  final String? refNo;
  final String? remarks;

  Collection({
    this.customerId,
    this.prevDues,
    this.invoiceNo,
    this.cashmemoNo,
    this.collectionDate,
    this.paymentMethod,
    this.collectedAmount,
    this.chequeNo,
    this.chequeDate,
    this.invoiceCollected,
    this.invoiceDue,
    this.refNo,
    this.remarks,
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
      'inv_collected' : invoiceCollected,
      'inv_due' : invoiceDue,
      'payment_check_no' : chequeNo,
      'cheque_date' : chequeDate,
      'ref_no' : refNo,
      'remarks' : remarks,
    };
  }
}
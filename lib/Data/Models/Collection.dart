import '../../Domain/Entities/Collection_entities.dart';

class CollectionModel extends Collection {
  CollectionModel({
    String? customerId,
    String? prevDues,
    String? invoiceNo,
    String? cashmemoNo,
    String? collectionDate,
    String? paymentMethod,
    String? collectedAmount,
  }) : super(
    customerId: customerId,
    prevDues: prevDues,
    invoiceNo: invoiceNo,
    cashmemoNo: cashmemoNo,
    collectionDate: collectionDate,
    paymentMethod: paymentMethod,
    collectedAmount: collectedAmount,
  );

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      customerId: json['customer_id'] as String?,
      prevDues: json['prev_dues'] as String?,
      invoiceNo: json['invoice_no'] as String?,
      cashmemoNo: json['cashmemo_no'] as String?,
      collectionDate: json['collection_date'] as String?,
      paymentMethod: json['payment_method'] as String?,
      collectedAmount: json['collected_ammount'] as String?,
    );
  }

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
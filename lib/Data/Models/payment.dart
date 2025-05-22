import '../../Domain/Entities/payment_entities.dart';

class PaymentMethodModel extends PaymentMethod {
  PaymentMethodModel({
    required String name,
    required String type,
    required String slug,
  }) : super(name: name, type: type, slug: slug);

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'slug': slug,
    };
  }
}
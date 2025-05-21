import '../../Domain/Entities/customer_entities.dart';

class CustomerModel extends Customer {
  CustomerModel({ required int id, required String name, required String phone, required double previousDue, }) : super(id: id, name: name, phone: phone, previousDue: previousDue);

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String? ?? 'No Phone Number',
      previousDue: (json['balance'] as num).toDouble(),
    );
  }

Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'previous_due': previousDue,
    };
  }
}
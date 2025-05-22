class PaymentMethod {
  final String name;
  final String type;
  final String slug;

  PaymentMethod({
    required this.name,
    required this.type,
    required this.slug,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      name: json['name'] as String,
      type: json['type'] as String,
      slug: json['slug'] as String,
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
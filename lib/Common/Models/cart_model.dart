import '../../Domain/Entities/product_entities.dart';

class CartItem {
  final ProductEntity product;
  final int quantity;
  final double totalPrice;
  final String? serial;

  CartItem({
    required this.product,
    required this.quantity,
    required this.totalPrice,
    this.serial,
  });
}
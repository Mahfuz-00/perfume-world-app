part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final ProductEntity product;
  final int quantity;

  const AddToCartEvent({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final ProductEntity product;

  const RemoveFromCartEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
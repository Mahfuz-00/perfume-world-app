part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> cartItems;

  const CartUpdated({required this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

class ClearCart extends CartEvent {}
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';

import '../../../Common/Models/cart_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) {
      final currentState = state;
      List<CartItem> updatedCart = currentState is CartUpdated ? List.from(currentState.cartItems) : [];
      final index = updatedCart.indexWhere((item) => item.product.code == event.product.code);
      if (index != -1) {
        final existingItem = updatedCart[index];
        updatedCart[index] = CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + event.quantity,
          totalPrice: (double.tryParse(existingItem.product.price) ?? 0) * (existingItem.quantity + event.quantity),
        );
      } else {
        final totalPrice = (double.tryParse(event.product.price) ?? 0) * event.quantity;
        updatedCart.add(CartItem(product: event.product, quantity: event.quantity, totalPrice: totalPrice));
      }
      emit(CartUpdated(cartItems: updatedCart));
    });

    on<RemoveFromCartEvent>((event, emit) {
      print('RemoveFromCartEvent received for ${event.product.name}');
      final currentState = state;
      if (currentState is CartUpdated) {
        final updatedCart = List<CartItem>.from(currentState.cartItems)
          ..removeWhere((item) => item.product.code == event.product.code);
        print('Cart updated: ${updatedCart.length} items');
        emit(CartUpdated(cartItems: updatedCart));
      }
    });

    on<ClearCartEvent>((event, emit) {
      print('ClearCartEvent received');
      emit(CartUpdated(cartItems: []));
    });
  }
}
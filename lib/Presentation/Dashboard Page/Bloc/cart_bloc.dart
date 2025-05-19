import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';

import '../../../Common/Models/cart_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) {
      print('AddToCartEvent received for ${event.product.name}, quantity: ${event.quantity}');
      final currentState = state;
      List<CartItem> updatedCart = [];

      if (currentState is CartUpdated) {
        updatedCart = List.from(currentState.cartItems);
      }

      final totalPrice = (double.tryParse(event.product.price) ?? 0) * event.quantity;
      final newItem = CartItem(
        product: event.product,
        quantity: event.quantity,
        totalPrice: totalPrice,
      );

      updatedCart.add(newItem);
      print('Cart updated: ${updatedCart.length} items, total quantity: ${updatedCart.fold(0, (sum, item) => sum + item.quantity)}');
      emit(CartUpdated(cartItems: updatedCart));
    });

    on<ClearCartEvent>((event, emit) {
      print('ClearCartEvent received');
      emit(CartUpdated(cartItems: []));
    });
  }
}
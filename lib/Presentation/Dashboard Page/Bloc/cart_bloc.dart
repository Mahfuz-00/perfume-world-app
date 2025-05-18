import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../Domain/Entities/product_entities.dart';
import '../../../Common/Models/cart_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) {
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
      emit(CartUpdated(cartItems: updatedCart));
    });

    on<ClearCartEvent>((event, emit) {
      emit(CartUpdated(cartItems: []));
    });
  }
}
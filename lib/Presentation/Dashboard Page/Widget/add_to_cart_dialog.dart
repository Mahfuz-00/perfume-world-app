import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';
import '../Bloc/cart_bloc.dart';

class AddToCartDialog extends StatefulWidget {
  final ProductEntity product;
  final CartBloc cartBloc; // Add CartBloc as a parameter

  const AddToCartDialog({
    super.key,
    required this.product,
    required this.cartBloc,
  });

  @override
  _AddToCartDialogState createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(widget.product.price) ?? 0;
    final totalPrice = price * quantity;

    return AlertDialog(
      title: Text(
        'Add ${widget.product.name} to Cart',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Price per unit: ৳${price.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: AppColors.textAsh),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (quantity > 1) setState(() => quantity--);
                },
                icon: Icon(Icons.remove, size: 20),
              ),
              Text(
                '$quantity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto'),
              ),
              IconButton(
                onPressed: () {
                  setState(() => quantity++);
                },
                icon: Icon(Icons.add, size: 20),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Total: ৳${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Roboto', color: AppColors.primary),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: AppColors.textAsh),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            print('Adding to cart: ${widget.product.name}, quantity: $quantity');
            widget.cartBloc.add(AddToCartEvent(product: widget.product, quantity: quantity));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            'Add to Cart',
            style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: AppColors.backgroundWhite),
          ),
        ),
      ],
    );
  }
}
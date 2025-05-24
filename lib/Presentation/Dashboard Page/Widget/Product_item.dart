import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfume_world_app/core/config/assets/app_images.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';
import '../../../Common/Models/cart_model.dart';
import '../Bloc/cart_bloc.dart';

class ProductItem extends StatelessWidget {
  final ProductEntity product;
  final double width;

  const ProductItem({super.key, required this.product, required this.width});

  @override
  Widget build(BuildContext context) {
    print('CartBloc available in ProductItem: ${context.read<CartBloc>()}');
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        // Get current quantity in cart for this product
        final cartItems = cartState is CartUpdated ? cartState.cartItems : <CartItem>[];
        final currentQuantity = cartItems
            .where((item) => item.product.code == product.code)
            .fold(0, (sum, item) => sum + item.quantity);
        final stock = int.tryParse(product.quantity) ?? 0;

        return Container(
          width: width,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: AppColors.primary,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset(
              //   AppImages.ActivityIcon,
              //   fit: BoxFit.cover,
              //   height: MediaQuery.of(context).size.height * 0.15,
              //   width: double.infinity,
              //   errorBuilder: (context, error, stackTrace) => Icon(
              //     Icons.broken_image,
              //     size: 50,
              //     color: AppColors.textAsh,
              //   ),
              // ),
              SizedBox(height: 4),
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: AppColors.textAsh,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                'Serial: ${product.code}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  color: AppColors.textAsh,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                '৳${product.price}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'In Stock: ${product.quantity}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  color: AppColors.textAsh,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Warranty: ${product.warrantyDay} days',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  color: AppColors.textAsh,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //Single quantity
                    if (currentQuantity + 1 <= stock) {
                      context.read<CartBloc>().add(
                        AddToCartEvent(product: product, quantity: 1),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'No more stock',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              color: AppColors.backgroundWhite,
                            ),
                          ),
                          backgroundColor: AppColors.primary,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }


                    //Dialog for add multiple quantity
                    // showDialog(
                    //   context: context,
                    //   builder: (dialogContext) => AddToCartDialog(
                    //     product: product,
                    //     cartBloc: context.read<CartBloc>(),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: AppColors.backgroundWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
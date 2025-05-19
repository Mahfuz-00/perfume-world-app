import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';
import '../Bloc/cart_bloc.dart';
import 'add_to_cart_dialog.dart';

class ProductSearchWidget extends StatefulWidget {
  final List<ProductEntity> products;

  const ProductSearchWidget({super.key, required this.products});

  @override
  _ProductSearchWidgetState createState() => _ProductSearchWidgetState();
}

class _ProductSearchWidgetState extends State<ProductSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  ProductEntity? _foundProduct;

  void _searchProduct(String serial) {
    setState(() {
      _foundProduct = widget.products.firstWhere(
            (product) => product.code.toLowerCase() == serial.toLowerCase(),
        orElse: () => ProductEntity(
          id: 0,
          name: '',
          code: '',
          price: '0',
          quantity: '0',
          warrantyDay: '0',
          groupId: 0,
          categoryId: 0,
          brandId: 0,
          unitId: 0,
          discount: '0',
          model: '',
          lifeTime: '',
          openingBalance: 0,
          openingBalanceDate: '',
          slug: '',
          assetType: '',
          status: '',
          createdAt: null,
          updatedAt: null,
          stock: [] as StockEntity,
        ),
      );
      if (_foundProduct!.id == '') {
        _foundProduct = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by Serial Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: AppColors.primary),
              onPressed: () => _searchProduct(_searchController.text),
            ),
          ),
          onSubmitted: _searchProduct,
        ),
        SizedBox(height: 8),
        if (_foundProduct != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Found: ${_foundProduct!.name}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: AppColors.textAsh,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AddToCartDialog(
                      product: _foundProduct!,
                      cartBloc: context.read<CartBloc>(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
            ],
          )
        else if (_searchController.text.isNotEmpty)
          Text(
            'No product found',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              color: AppColors.textAsh,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';
import '../Bloc/cart_bloc.dart';
import 'add_to_cart_dialog.dart';

class ProductSearch extends StatefulWidget {
  final List<ProductEntity> products;
  final Function(String) onNameSearch;
  final Function(String) onSerialSearch;
  final CartBloc cartBloc;

  const ProductSearch({
    super.key,
    required this.products,
    required this.onNameSearch,
    required this.onSerialSearch,
    required this.cartBloc,
  });

  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  final TextEditingController _serialController = TextEditingController();
  ProductEntity? _foundProduct;

  @override
  void dispose() {
    _serialController.dispose();
    super.dispose();
  }

  void _searchProduct(String serial) {
    if (serial.isEmpty) {
      setState(() {
        _foundProduct = null;
      });
      widget.onSerialSearch(serial);
      return;
    }

    final matchedProduct = widget.products.firstWhere(
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

    setState(() {
      _foundProduct = matchedProduct.id != 0 ? matchedProduct : null;
    });

    widget.onSerialSearch(serial);

// Check stock and add to cart directly on exact match
    if (_foundProduct != null) {
      final availableStock = int.tryParse(_foundProduct!.quantity) ?? 0;
      if (availableStock >= 1) {
        widget.cartBloc.add(AddToCartEvent(
          product: _foundProduct!,
          quantity: 1,
        ));
        print('AddToCartEvent dispatched for ${_foundProduct!.name}, quantity: 1');
// Clear the serial field after adding to cart
        _serialController.clear();
        setState(() {
          _foundProduct = null;
        });
        widget.onSerialSearch('');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Insufficient stock for ${_foundProduct!.name}',
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by Product',
                  hintStyle: TextStyle(fontSize: 12, color: AppColors.textAsh),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                    BorderSide(color: AppColors.textAsh.withOpacity(0.3)),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                style: TextStyle(fontSize: 12, fontFamily: 'Roboto'),
                onChanged: widget.onNameSearch,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _serialController,
                decoration: InputDecoration(
                  hintText: 'Search by Serial',
                  hintStyle: TextStyle(fontSize: 12, color: AppColors.textAsh),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                    BorderSide(color: AppColors.textAsh.withOpacity(0.3)),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                style: TextStyle(fontSize: 12, fontFamily: 'Roboto'),
                onChanged: _searchProduct,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        if (_foundProduct != null)
          Text(
            'Found: ${_foundProduct!.name}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              color: AppColors.textAsh,
            ),
          )
        else if (_serialController.text.isNotEmpty)
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
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';
import '../Bloc/cart_bloc.dart';
import 'product_item.dart';
import 'search_boxes.dart';

class ProductList extends StatefulWidget {
  final List<ProductEntity> products;

  const ProductList({super.key, required this.products});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String nameQuery = '';
  String serialQuery = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 24;
    final itemWidth = (availableWidth - 12) / 2;
    final filteredProducts = widget.products.where((product) {
      final nameMatch = product.name.toLowerCase().contains(nameQuery.toLowerCase());
      final serialMatch = product.code.toLowerCase().contains(serialQuery.toLowerCase());
      return nameMatch && serialMatch;
    }).toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                width: screenWidth * 0.3,
                child: ProductSearch(
                  products: widget.products,
                  onNameSearch: (value) => setState(() => nameQuery = value),
                  onSerialSearch: (value) => setState(() => serialQuery = value),
                  cartBloc: context.read<CartBloc>(),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          filteredProducts.isEmpty
              ? Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text('No products available'),
            ),
          )
              : SizedBox(
            height: MediaQuery.of(context).size.height - 50, // Adjust based on available space
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4, // Adjust for desired height (width/height ratio)
              children: filteredProducts.map((product) {
                return SizedBox(
                  width: itemWidth,
                  child: ProductItem(
                    product: product,
                    width: itemWidth,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
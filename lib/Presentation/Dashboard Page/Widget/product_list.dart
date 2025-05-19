import 'package:flutter/material.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';
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
                width: screenWidth * 0.5,
                child: ProductSearch(
                  onNameSearch: (value) => setState(() => nameQuery = value),
                  onSerialSearch: (value) => setState(() => serialQuery = value),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          filteredProducts.isEmpty
              ? Center(child: Text('No products available'))
              : Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.start,
            children: filteredProducts.map((product) {
              return ProductItem(
                product: product,
                width: (screenWidth - 48) / 3,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
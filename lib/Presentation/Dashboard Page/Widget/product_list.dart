import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfume_world_app/Presentation/Dashboard%20Page/Widget/search_boxes.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';
import 'package:perfume_world_app/Domain/Entities/product_entities.dart';
import '../bloc/dashboard_bloc.dart';
import 'product_item.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String nameQuery = '';
  String serialQuery = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DashboardLoadedState) {
                final allProducts = state.dashboardData as List<ProductEntity>;
                final products = allProducts.where((product) {
                  final nameMatch = product.name.toLowerCase().contains(nameQuery.toLowerCase());
                  final serialMatch = product.code.toLowerCase().contains(serialQuery.toLowerCase());
                  return nameMatch && serialMatch;
                }).toList();

                if (products.isEmpty) {
                  return Center(child: Text('No products available'));
                }

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.start,
                  children: products.map((product) {
                    return ProductItem(
                      product: product,
                      width: (screenWidth - 48) / 3,
                    );
                  }).toList(),
                );
              } else if (state is DashboardErrorState) {
                print('Dashboard Error: ${state.message}');
                return Center(child: Text('Error: ${state.message}'));
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/config/theme/app_colors.dart';

class ProductSearch extends StatelessWidget {
  final Function(String) onNameSearch;
  final Function(String) onSerialSearch;

  const ProductSearch({
    super.key,
    required this.onNameSearch,
    required this.onSerialSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by Product',
              hintStyle: TextStyle(fontSize: 12, color: AppColors.textAsh),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.textAsh.withOpacity(0.3)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: TextStyle(fontSize: 12, fontFamily: 'Roboto'),
            onChanged: onNameSearch,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by Serial',
              hintStyle: TextStyle(fontSize: 12, color: AppColors.textAsh),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.textAsh.withOpacity(0.3)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: TextStyle(fontSize: 12, fontFamily: 'Roboto'),
            onChanged: onSerialSearch,
          ),
        ),
      ],
    );
  }
}
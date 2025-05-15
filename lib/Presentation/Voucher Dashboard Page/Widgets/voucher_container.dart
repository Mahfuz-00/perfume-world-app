import 'package:flutter/material.dart';

import '../../../Core/Config/Theme/app_colors.dart';

class VoucherStatusTemplate extends StatelessWidget {
  final String? imageAsset; // Nullable imageAsset to allow no image
  final String label;
  final num number;
  final Color? color; // Nullable color field

  const VoucherStatusTemplate({
    required this.label,
    required this.number,
    this.imageAsset, // Image asset is optional
    this.color, // Color is optional
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.255,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.containerBackgroundGrey100,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Conditionally display image or circular color container
              imageAsset != null && imageAsset!.isNotEmpty
                  ? Image.asset(
                imageAsset!,
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              )
                  : (color != null
                  ? Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              )
                  : SizedBox.shrink()), // Empty widget if neither image nor color
              SizedBox(width: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBlack,
                  fontFamily: 'Roboto',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          SizedBox(height: 4), // Spacing between label and number
          Text(
            'TK. $number',
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
              color: AppColors.textBlack,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../Core/Config/Theme/app_colors.dart';

class AppBarModel extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? color;
  const AppBarModel({
    super.key, required this.title, this.color
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);  // Specify the height for your custom AppBar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color??AppColors.backgroundWhite,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // To go back to the previous page
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.containerBackgroundPurple, // Background color
              shape: BoxShape.circle,     // Makes it circular
              /* boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],*/
            ),
            padding: EdgeInsets.all(8), // Adjust padding for better spacing
            child: Icon(
              Icons.arrow_back_ios_new_outlined, // Back arrow icon
              color: AppColors.primary, // Color of the icon
              size: 16, // Icon size
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: color != null ? AppColors.textWhite: AppColors.textBlack,
            fontFamily: 'Roboto'),
      ),
      centerTitle: true,
    );
  }
}
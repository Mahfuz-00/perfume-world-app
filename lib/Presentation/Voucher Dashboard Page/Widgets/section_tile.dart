import 'package:flutter/material.dart';

import '../../../Core/Config/Theme/app_colors.dart';

class SectionTile extends StatelessWidget {
  final String title;
  final String count;
  final String selectedSection;
  final Function(String) onTap;

  SectionTile({
    required this.title,
    required this.count,
    required this.selectedSection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          onTap(title);  // Pass the section title on tap
        },
        child: Container(
          decoration: BoxDecoration(
            color: selectedSection == title
                ? AppColors.textNavyBlue
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  color: selectedSection == title
                      ? Colors.white
                      : AppColors.textBlack,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(width: 5.0),
              CircleAvatar(
                radius: 12.0,
                backgroundColor: selectedSection == title
                    ? AppColors.containerBackgroundRed
                    : AppColors.containerBackgroundGrey300,
                child: Text(
                  count,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

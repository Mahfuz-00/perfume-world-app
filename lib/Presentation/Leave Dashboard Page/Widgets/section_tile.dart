import 'package:flutter/material.dart';

import '../../../Core/Config/Theme/app_colors.dart';

class SectionTile extends StatelessWidget {
  final String title;
/*  final Widget count;*/
  final String count;
  final String selectedSection;
  final Function(String) onTap;

  const SectionTile({
    Key? key,
    required this.title,
    required this.count,
    required this.selectedSection,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => onTap(title), // Trigger onTap to update selected section
        child: Container(
          decoration: BoxDecoration(
            color: selectedSection == title ? AppColors.NavyBlue : Colors.transparent, // Change color if selected
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
                  color: selectedSection == title ? Colors.white : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(width: 5.0),
              CircleAvatar(
                radius: 12.0,
                backgroundColor: Colors.grey[300], // Background color for the circle
                child: Center(
                  child: /*count*/ Text(
                    count,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
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

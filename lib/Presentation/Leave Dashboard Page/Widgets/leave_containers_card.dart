import 'package:flutter/material.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class LeaveContainers extends StatelessWidget {
  final String submitDate; // Label text
  final String leaveDate; // Leave Date string
  final String totalLeave; // Total Leave string
  final String approvedBy; // Name or title of person who approved
  final String approvalDate; // Date of approval
  final String approvedImage; // Image asset of the person who approved

  const LeaveContainers({
    required this.submitDate,
    required this.leaveDate,
    required this.totalLeave,
    required this.approvedBy,
    required this.approvalDate,
    required this.approvedImage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.925, // Adjust width as needed
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with image and label
          Row(
            children: [
              Image.asset(
                AppImages.LeavePageImage,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 8),
              Text(
                submitDate,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Space between Row and inner container

          // Inner container with two columns (Leave Date and Total Leave)
          Container(
            //margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1, // Specify the border width
                color: AppColors
                    .containerBackgroundGrey300, // Specify the border color
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leave Date',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      leaveDate,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Leave',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      totalLeave,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Space between inner container and approval section

          // Approval Section moved to be part of the outer container
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 14,
                  ),
                  SizedBox(width: 4,),
                  Text(
                    'Approved at $approvalDate',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                'By',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage(approvedImage),
              ),
              SizedBox(width: 8),
              Text(
                approvedBy,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

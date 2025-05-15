import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class VoucherCard extends StatelessWidget {
  final dynamic submitDate;
  final dynamic project;
  final dynamic expense;
  final dynamic approvedBy;
  final dynamic approvalDate;

/*  final String approvedImage;*/

  const VoucherCard({
    required this.submitDate,
    required this.project,
    required this.expense,
    required this.approvedBy,
    required this.approvalDate,
    /*  required this.approvedImage,*/
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    DateTime parsedApprovedDate = DateTime.parse(submitDate);
    String ApprovedDate = DateFormat('dd MMMM yyyy').format(parsedApprovedDate);

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
                ApprovedDate,
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
                      'Type',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                     Text(
                      project.toString() == ''? 'N/A' : project.toString(),
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
                      'Total Expense',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'TK. ${expense.toString()}',
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
              /*   Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 14,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Approved at ${approvalDate.toString()}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Spacer(),*/
              if (ApprovedDate != null) ...[
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 14,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Approved By',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBlack,
                  ),
                ),
              ] else ...[
                Text(
                  'By',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
              /*SizedBox(width: 8),
              CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage(approvedImage),
              ),*/
              SizedBox(width: 8),
              Text(
                approvedBy.toString() == '' ? 'N/A' : approvedBy.toString(),
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

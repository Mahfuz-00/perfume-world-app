import 'package:flutter/material.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import 'meeting_card.dart';
import 'task_card.dart';

// Class to hold the images, headers, and subtitles and pass them as input
class CardsWidget extends StatelessWidget {
  final String header; // First header
  final String? subtitle; // First subtitle
  final String? totalCount;

  //final List<Map<String, dynamic>> secondCardData;
  final MeetingCard? meetingCard; // Nullable Meeting Card widget
  final TaskCard? taskCard; // Nullable Task Card widget
  final Widget? leaveCard; // Nullable Leave Card widget
  final Widget? attendanceCard;
  final Widget? voucherCard;

  // Constructor to accept images, headers, and subtitles as input
  CardsWidget({
    required this.header,
    this.subtitle,
    //required this.secondCardData,
    this.totalCount,
    this.meetingCard,
    this.taskCard,
    this.leaveCard,
    this.attendanceCard,
    this.voucherCard,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header and Subtitle 1
              Row(
                children: [
                  Text(
                    header, // First Header
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                        fontFamily: 'Roboto'),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  if(totalCount != null) ...[
                    Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDarkGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          totalCount.toString(),
                          // Replace with dynamic meeting count
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 4),
              if(subtitle != null) ...[
                Text(
                  subtitle!, // First Subtitle
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                      fontFamily: 'Roboto'),
                ),
                SizedBox(height: 5),
              ],

              // Conditionally render the relevant card
              if (meetingCard != null) meetingCard!,
              // Render Meeting Card if provided
              if (taskCard != null) taskCard!,
              // Render Task Card if provided
              if (leaveCard != null) leaveCard!,
              // Render Leave Card if provided
              if (attendanceCard!= null) attendanceCard!,
              // Render Attendance Card if provided
              if (voucherCard!= null) voucherCard!,
              // Render Voucher Card if provided
            ],
          ),
        ),
      ),
    );
  }
}





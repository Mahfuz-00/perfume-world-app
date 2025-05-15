import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class LeaveCard extends StatefulWidget {
  final String leaveHeader;
  final String Date;
  final String Status;
  final String UsedLeave;
  final String AvailableLeave;

  const LeaveCard({
    super.key,
    required this.leaveHeader,
    required this.Date,
    required this.Status,
    required this.UsedLeave,
    required this.AvailableLeave,
  });

  @override
  State<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  //late double _progress;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String _formatDate(String date) {
      try {
        print(date);

        // First try parsing the date as ISO 8601 (yyyy-MM-dd)
        DateTime parsedDate =
            DateTime.parse(date); // yyyy-MM-dd or yyyy-MM-ddTHH:mm:ss format
        return DateFormat('MMM dd').format(parsedDate); // Format to "MMM dd"
      } catch (e) {
        // If that fails, try parsing the date with custom format (MM-dd-yyyy)
        try {
          DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
          return DateFormat('MMM dd').format(parsedDate); // Format to "MMM dd"
        } catch (e) {
          // If both parsing attempts fail, return the original string
          return date;
        }
      }
    }

    String Status = 'N/A';

    if (widget.Status == 'pending') {
      Status = 'Pending';
    } else if (widget.Status == 'approved') {
      Status = 'Approved';
    } else if (widget.Status == 'not_approve') {
      Status = 'Rejected';
    }

    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Card(
        color: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
                width: 1, color: AppColors.containerBackgroundGrey300)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.leaveHeader == '') ...[
                Center(
                  child: Text(
                    'No Recent Leave',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textGrey,
                        fontFamily: 'Roboto'),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 8),
              ],
              if (widget.leaveHeader.isNotEmpty) ...[
                // Row with circular logo, header, and time spreader
                Row(
                  children: [
                    // Circular Logo
                    CircleAvatar(
                      radius: 16,
                      child: Image.asset(AppImages.LeaveIcon2),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.leaveHeader, // Second Header
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDarkBlack,
                            fontFamily: 'Roboto'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 8), // Spacing between elements
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        //color: AppColors.textWhite,
                        borderRadius: BorderRadius.circular(4),
                        /*border: Border.all(color: AppColors.textWhite), */ // Adjust border color as needed
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppImages.CalenderIcon,
                            color: Colors.grey,
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(width: 5), // Spacing between icon and text
                          Text(
                            /*widget.date*/
                            _formatDate(widget.Date), // Replace with your date
                            style: TextStyle(
                                color: AppColors.textBlack,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
              Row(
                // First row with Section 1 and Section 2
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.leaveHeader.isNotEmpty) ...[
                    // Section 1 (Timer Status)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      //width: screenWidth * 0.20,
                      //height: screenHeight * 0.035,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.containerBackgroundGrey300,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (Status == 'Pending') ...[
                            Icon(
                              Icons.timer, // Timer icon
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          ] else if (Status == 'Approved') ...[
                            Icon(
                              Icons.check, // Timer icon
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          ] else if (Status == 'Rejected') ...[
                            Icon(
                              Icons.not_interested_outlined, // Timer icon
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          ],
                          SizedBox(width: 5),
                          Text(
                            Status,
                            style: TextStyle(
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                  ],

                  // Section 2 (Leave Used)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .grey[300], // Background color of the circle
                          ),
                          child: Center(
                            child: Text(
                              widget.UsedLeave.toString(),
                              // Replace with dynamic value
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Leave Used', // Replace with dynamic text
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            fontFamily: 'Roboto',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 5), // Spacer between rows

                  // Section 3 (Always in next line - Available Leave)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .grey[300], // Background color of the circle
                          ),
                          child: Center(
                            child: Text(
                              widget.AvailableLeave.toString(),
                              // Replace with dynamic value
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Available Leave', // Replace with dynamic text
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            fontFamily: 'Roboto',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

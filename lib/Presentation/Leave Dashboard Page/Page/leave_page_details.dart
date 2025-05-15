import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Common/Widgets/appbar_model.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/leave_entities.dart';

class LeaveDetailPage extends StatefulWidget {
  List<LeaveBodyEntity> leaves;
  int initialIndex;

  LeaveDetailPage({required this.leaves, required this.initialIndex});

  @override
  State<LeaveDetailPage> createState() => _LeaveDetailPageState();
}

class _LeaveDetailPageState extends State<LeaveDetailPage> {
  String? _formatDate(String? date) {
    try {
      print(date);

      // First try parsing the date as ISO 8601 (yyyy-MM-dd)
      DateTime parsedDate =
          DateTime.parse(date!); // yyyy-MM-dd or yyyy-MM-ddTHH:mm:ss format
      return DateFormat('dd MMM yyyy').format(parsedDate); // Format to "MMM dd"
    } catch (e) {
      // If that fails, try parsing the date with custom format (MM-dd-yyyy)
      try {
        DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date!);
        return DateFormat('dd MMM yyyy')
            .format(parsedDate); // Format to "MMM dd"
      } catch (e) {
        // If both parsing attempts fail, return the original string
        return date;
      }
    }
  }

  String convertLeaveTypeToName(String leaveType) {
    switch (leaveType.toLowerCase()) {
      case 'casual_leave':
        return 'Casual';
      case 'sick_leave':
        return 'Sick';
      case 'medical_leave':
        return 'Medical';
      default:
        return 'Unknown';
    }
  }


  List<LeaveBodyEntity> leaveList = [
    // Add your tasks here
  ];
  int currentIndex = 0;

  String? startdate;
  String? enddate;
  String? submittedDate;
  String? visibleName;
  int? tappedIndex;
  String? showName;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    print(widget.leaves.length);

    final leave = widget.leaves[currentIndex];

    startdate = _formatDate(leave.startDate);
    enddate = _formatDate(leave.endDate);
    submittedDate = _formatDate(leave.createdAt);

    String leaveTypeName = convertLeaveTypeToName(leave.leaveType);

    String Status = 'N/A';
    if (leave.status == 'pending') {
      Status = 'Pending';
    }

    if (leave.status == 'approved') {
      Status = 'Approved';
    }

    if (leave.status == 'rejected') {
      Status = 'Rejected';
    }

    return Scaffold(
      appBar: AppBarModel(
        title: 'Leave Details',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppImages.AttendanceConatinerIcon,
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: textSize16Darker('${leaveTypeName ?? 'N/A'} Leave')),
                  ],
                ),
                SizedBox(height: 20),
                textSize16Darker('Start Date'),
                textSize14Lighter('${startdate ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('End Date'),
                textSize14Lighter('${enddate ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Total Days'),
                textSize14Lighter('${leave.totalDay ?? 'N/A'} Days'),
                SizedBox(height: 10),
                textSize16Darker('Reason'),
                textSize14Lighter('${leave.reason ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Responsible person while in leave'),
                textSize14Lighter('${leave.responsiblePersonName ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('leave Submitted Date'),
                textSize14Lighter('${submittedDate ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Status'),
                textSize14Lighter('${Status ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Approved by'),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: leave.approverPhoto == null
                          ? Image.asset(AppImages.HRImage)
                              .image // Show default image if the URL is empty
                          : Image.network(
                              leave.approverPhoto!,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image');
                                // Return default image if the URL fails to load
                                return Image.asset(AppImages.HRImage);
                              },
                            ).image,
                    ),
                    SizedBox(width: 8),
                    textSize14Lighter('${leave.approverId ?? 'N/A'}'),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: screenHeight * 0.18,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: screenHeight * 0.1,
              width: screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: currentIndex > 0
                          ? () {
                              setState(() {
                                currentIndex--;
                              });
                            }
                          : null, // Disable the button if at the first task
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentIndex > 0
                            ? AppColors.primary
                            : AppColors.textGrey,
                        // Grey out the button if no previous task
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        fixedSize: Size(screenWidth * 0.42, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Previous', // Change the text to "Previous"
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: currentIndex < widget.leaves.length - 1
                          ? () {
                              setState(() {
                                currentIndex++;
                              });
                            }
                          : null, // Disable the button if at the last task
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentIndex < widget.leaves.length - 1
                            ? AppColors.primary
                            : AppColors.textGrey,
                        // Grey out the button if no next task
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        fixedSize: Size(screenWidth * 0.42, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BottomNavBar(
                containerHeight: screenHeight * 0.08,
                currentPage: '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Template 1: Text size 16, darker
  Widget textSize16Darker(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlack,
        fontFamily: 'Roboto',
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 5,
    );
  }

// Template 2: Text size 14, lighter
  Widget textSize14Lighter(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textGrey,
        fontFamily: 'Roboto',
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 20,
    );
  }
}

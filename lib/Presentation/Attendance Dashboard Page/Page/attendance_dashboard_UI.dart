import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Helper/navigation_transition.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../Bloc/attendance_bloc.dart';
import '../Widget/attendance_container.dart';
import '../Widget/attendance_modal_slider.dart';

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  bool isModalOpen = false;
  final TextEditingController _entrytimeController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(FetchAttendanceRequestsEvent());
  }

  String getPaidPeriodString() {
    // Get today's date
    DateTime today = DateTime.now();

    // Format the start date of the month (1st of the current month)
    DateTime startDate = DateTime(today.year, today.month, 1);
    String startDateFormatted =
        DateFormat('d MMM yyyy').format(startDate); // "1 Jan 2025"

    // Get the last day of the current month
    DateTime endDate =
        DateTime(today.year, today.month + 1, 0); // Last day of current month
    String endDateFormatted = DateFormat('d MMM yyyy')
        .format(endDate); // "31 Jan 2025" or last day of the month

    // Return the final formatted string
    return 'Paid Period $startDateFormatted - $endDateFormatted';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String paidPeriod = getPaidPeriodString();

    return InternetConnectionChecker(
      child: Scaffold(
        body: BlocListener<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<AttendanceBloc, AttendanceState>(
            builder: (context, state) {
              if (state is AttendanceLoading) {
                return Center(child: OverlayLoader());
              } else if (state is AttendanceLoaded) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        // First container (30% of the screen height)
                        Column(
                          children: [
                            designContainer(screenHeight),

                            // Third container (Rest of the body content below Container 1)
                            listContainer(screenWidth, screenHeight),
                          ],
                        ),

                        // Second container (Stacked on top of Container 1 and Container 3)
                        summaryContainer(
                            screenHeight, paidPeriod, screenWidth, context),
                      ],
                    ),
                  ),
                );
              } else if (state is AttendanceError) {
                return Center(child: Text(state.message));
              }
              return Center(child: Text('No data'));
            },
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: screenHeight * 0.08,
          child: BottomNavBar(
            containerHeight: screenHeight * 0.08,
            currentPage: 'Attendance',
          ),
        ),
      ),
    );
  }

  Container listContainer(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      color: AppColors.containerBackgroundGrey300,
      padding: EdgeInsets.only(top: screenHeight * 0.09 + 70),
      child: Builder(
        builder: (context) {
          final attendanceList = (BlocProvider.of<AttendanceBloc>(context).state
                  as AttendanceLoaded)
              .attendances;

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20),
            itemCount: attendanceList.length,
            itemBuilder: (context, index) {
              final attendance = attendanceList[index];

              DateTime parsedDateTime = DateTime.parse(attendance.inTime!);

              String inDate = DateFormat('dd MMMM yyyy')
                  .format(parsedDateTime); // "10 January 2025"
              String inTime =
                  DateFormat('hh:mm a').format(parsedDateTime); // "10:00 AM"

              print('Date: $inDate');
              print('Time: $inTime');

              return Column(
                children: [
                  AttendenceContainers(
                    date: inDate,
                    projectName: attendance.projectName == '' ? 'Head Office': attendance.projectName!,
                    location: 'Mirpur - 12',
                    duration: '00:00 Hours',
                    clockIn: inTime,
                    clockOut: '06:00 PM',
                    approvedby: attendance.supervisorUserId.toString(),
                    approvedDate: inDate,
                    approverImage: AppImages.HRImage, // or from data if dynamic
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Positioned summaryContainer(double screenHeight, String paidPeriod,
      double screenWidth, BuildContext context) {
    return Positioned(
      top: screenHeight * 0.15,
      // Adjust to start over Container 1
      left: 0,
      right: 0,
      child: Container(
        height: screenHeight * 0.19 + 70,
        // Height of Container 2 (should cover part of Container 1)
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Working Hours',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                    fontFamily: 'Roboto'),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                paidPeriod,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.labelGrey,
                    fontFamily: 'Roboto'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth * 0.4,
                    //margin: EdgeInsets.symmetric(horizontal: 10),
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
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                // Apply the color here
                                shape: BoxShape
                                    .circle, // Make it round like an icon
                              ),
                              child: Icon(
                                Icons.access_time_filled,
                                size: 12,
                              ),
                            ),
                            SizedBox(width: 3),
                            // Spacing between image and label
                            Text(
                              'Today',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textBlack,
                                  fontFamily: 'Roboto'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        // Spacing between label and number
                        StreamBuilder<int>(
                          stream: Stream.periodic(
                              Duration(seconds: 1), (count) => count),
                          builder: (context, snapshot) {
                            final attendanceList =
                                (BlocProvider.of<AttendanceBloc>(context).state
                                        as AttendanceLoaded)
                                    .attendances;

                            // Assuming the first attendance is being used for display
                            final attendance = attendanceList.isNotEmpty
                                ? attendanceList[0]
                                : null;

                            if (attendance == null) {
                              return Text(
                                '00:00 Hours',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textBlack,
                                  fontFamily: 'Roboto',
                                ),
                              );
                            }

                            // Parse 'inTime' to DateTime
                            DateTime parsedDateTime =
                                DateTime.parse(attendance.inTime!);

                            // Format the date and time
                            String inDate = DateFormat('dd MMMM yyyy').format(
                                parsedDateTime); // e.g., "10 January 2025"
                            String inTime = DateFormat('hh:mm a')
                                .format(parsedDateTime); // e.g., "10:00 AM"

                            // Get today's date in the same format as inDate
                            String todayDate = DateFormat('dd MMMM yyyy')
                                .format(DateTime.now());

                            // Compare if inDate is today
                            bool isToday = inDate == todayDate;

                            String timeDifference = '00:00 Hours';

                            if (isToday) {
                              // Current time
                              DateTime now = DateTime.now();

                              // Calculate the time difference
                              Duration diff = now.difference(parsedDateTime);

                              // Format the time difference (in hours, minutes, and seconds)
                              timeDifference =
                                  "${diff.inHours}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')} Hours";
                            }

                            return Text(
                              timeDifference,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBlack,
                                fontFamily: 'Roboto',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.4,
                    //margin: EdgeInsets.symmetric(horizontal: 10),
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
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                // Apply the color here
                                shape: BoxShape
                                    .circle, // Make it round like an icon
                              ),
                              child: Icon(
                                Icons.access_time_filled,
                                size: 12,
                              ),
                            ),
                            SizedBox(width: 3),
                            // Spacing between image and label
                            Text(
                              'This Pay Period',
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textBlack,
                                  fontFamily: 'Roboto'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        // Spacing between label and number
                        Text('32:00 Hours',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBlack,
                                fontFamily: 'Roboto')),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Bottom Slider
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Color(0x00000000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (BuildContext context) {
                          // Using addPostFrameCallback to setState after the build phase
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              isModalOpen = true;
                            });
                          });

                          return BottomSlider(
                            isModalOpen: isModalOpen,
                            onModalStateChanged: (isOpen) {
                              setState(() {
                                isModalOpen = isOpen;
                              });
                            },
                            entrytimeController: _entrytimeController,
                            locationController: _locationController,
                            projectController: _projectController,
                            remarkController: _remarkController,
                          );
                        },
                      ).whenComplete(() {
                        // This will be called when the modal is dismissed
                        setState(() {
                          isModalOpen = false;
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      fixedSize: Size(screenWidth * 0.85, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Check In Now',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textWhite,
                      ),
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

  Container designContainer(double screenHeight) {
    return Container(
      height: screenHeight * 0.25,
      // First container occupies 30% of the screen height
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 30),
      color: AppColors.primary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Let\'s Check In!',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                      fontFamily: 'Roboto'),
                ),
                SizedBox(height: 5),
                Text(
                  'Don\'t miss your check in schedule',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                      fontFamily: 'Roboto'),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Image.asset(
              AppImages.AttendanceImage,
              height: 100,
              width: 100,
            ),
          )
        ],
      ),
    );
  }
}

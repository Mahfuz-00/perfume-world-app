import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Helper/navigation_transition.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Common/Widgets/bottom_navigation_bar_with_swipe.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/leave_entities.dart';
import '../../Activity Dashboard Page/Widget/status_container_template.dart';
import '../../Dashboard Page/Widget/task_card.dart';
import '../../Leave Creation Page/Page/leave_creation_UI.dart';
import '../Bloc/leave_bloc.dart';
import '../Widgets/leave_container.dart';
import '../Widgets/leave_containers_card.dart';
import '../Widgets/section_tile.dart';
import 'leave_page_details.dart';

class LeaveDashboard extends StatefulWidget {
  const LeaveDashboard({super.key});

  @override
  State<LeaveDashboard> createState() => _LeaveDashboardState();
}

class _LeaveDashboardState extends State<LeaveDashboard> {
  String selectedSection = 'Pending';

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
  void initState() {
    super.initState();
    BlocProvider.of<LeaveBloc>(context).add(LoadLeaveApplications());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String paidPeriod = getPaidPeriodString();

    return InternetConnectionChecker(
      child: Scaffold(
        body: BlocListener<LeaveBloc, LeaveState>(
          listener: (context, state) {
            // Handle different states and show snack bars or other UI updates
            if (state is LeaveApplicationError) {
              print('Error: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<LeaveBloc, LeaveState>(
            builder: (context, state) {
              if (state is LeaveApplicationLoading) {
                return Center(child: OverlayLoader());
              } else if (state is LeaveApplicationLoaded) {
                int _getLeaveCountByStatus(String status) {
                  // Filter leave records by status
                  int count = state.leaveApplications
                      .expand((leaveEntity) => leaveEntity
                          .leaveRecords) // Flatten the leaveRecords lists
                      .where((leave) =>
                          leave.status.toLowerCase() ==
                          status.toLowerCase()) // Filter by status
                      .toList()
                      .length;
                  return count;
                }

                print('Loaded: ${state.leaveApplications.toString()}');
                print(
                    'Remaining Days: ${state.leaveApplications[0].remainingDays}');

                final usedDays =
                    14 - int.parse(state.leaveApplications[0].remainingDays);

                List<LeaveEntity> filteredLeaveApplications = state
                    .leaveApplications
                    .where((leave) => leave.leaveRecords.any((record) =>
                        record.status.toLowerCase() ==
                        selectedSection.toLowerCase()))
                    .toList();

                print(
                    'Filtered Initial Leave Applications: ${filteredLeaveApplications}');

                // Now filter the leaveRecords for each LeaveEntity
                List<List<LeaveBodyEntity>> filteredLeaveRecords =
                    filteredLeaveApplications.map((leave) {
                  return leave.leaveRecords
                      .where((record) =>
                          record.status.toLowerCase() ==
                          selectedSection.toLowerCase())
                      .toList();
                }).toList();

                filteredLeaveRecords.forEach((records) {
                  print('Filtered Leave Records: $records');
                });

                return SafeArea(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        // First container (30% of the screen height)
                        Column(
                          children: [
                            designContainer(screenHeight),

                            // Third container (Rest of the body content below Container 1)
                            Container(
                              width: screenWidth,
                              color: AppColors.containerBackgroundGrey300,
                              padding: EdgeInsets.only(
                                  top: screenHeight * 0.09 + 20),
                              child: Column(
                                children: [
                                  // Second container with leave sections
                                  selectionBar(
                                      screenWidth, _getLeaveCountByStatus),
                                  SizedBox(height: 20),
                                  filteredLeaveRecords.isEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50.0),
                                          child: Center(
                                            child: Text(
                                              'No leaves available',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textGrey,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        )
                                      : listContainer(filteredLeaveRecords),
                                  SizedBox(height: 20),
                                ],
                              ),
                            )
                          ],
                        ),

                        // Second container (Stacked on top of Container 1 and Container 3)
                        SummaryContainer(
                            screenHeight, paidPeriod, state, usedDays),
                      ],
                    ),
                  ),
                );
              } else if (state is LeaveApplicationError) {
                return Center(child: Text("Error: ${state.message}"));
              } else {
                return Center(child: Text("No Data"));
              }
            },
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
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        customPageRoute(LeaveCreation()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      fixedSize: Size(screenWidth * 0.9, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'New Leave',
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
              Expanded(
                child: BottomNavBar(
                  containerHeight: screenHeight * 0.08,
                  currentPage: 'Leave',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView listContainer(List<List<LeaveBodyEntity>> filteredLeaveRecords) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredLeaveRecords.length,
      itemBuilder: (context, index) {
        final leave = filteredLeaveRecords[index];
        print(filteredLeaveRecords[index]);
        print(leave);

        // Filter all matching records in the leave's leaveRecords
        List<LeaveBodyEntity> matchingRecords = leave
            .where(
              (record) =>
                  record.status.toLowerCase() == selectedSection.toLowerCase(),
            )
            .toList();

        // If there are no matching records, return an empty widget
        if (matchingRecords.isEmpty) {
          return SizedBox.shrink();
        }

        // Build a list of widgets for each matching record
        return Column(
          children: matchingRecords.map((matchingRecord) {
            // Format Dates
            DateTime parsedStartDate = DateTime.parse(matchingRecord.startDate);
            DateTime parsedEndDate = DateTime.parse(matchingRecord.endDate);
            DateTime parsedCreatedDate =
                DateTime.parse(matchingRecord.createdAt);
            DateTime parsedUpdatedDate =
                DateTime.parse(matchingRecord.updatedAt);

            String startDate =
                DateFormat('dd MMM yyyy').format(parsedStartDate);
            String endDate = DateFormat('dd MMM yyyy').format(parsedEndDate);
            String createdDate =
                DateFormat('dd MMMM yyyy').format(parsedCreatedDate);
            String updatedDate =
                DateFormat('dd MMMM yyyy').format(parsedUpdatedDate);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the new page and pass task data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaveDetailPage(
                            leaves: matchingRecords,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: LeaveContainers(
                      submitDate: createdDate,
                      leaveDate: '$startDate - $endDate',
                      totalLeave: '${matchingRecord.totalDay} day(s)',
                      approvedBy: matchingRecord.name ?? 'N/A',
                      approvalDate: updatedDate,
                      approvedImage: matchingRecord.approverPhoto ?? 'Unknown',
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Padding selectionBar(
      double screenWidth, int _getLeaveCountByStatus(String status)) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SectionTile(
              title: 'Pending',
              count: _getLeaveCountByStatus('pending').toString(),
              selectedSection: selectedSection,
              onTap: (section) {
                setState(() {
                  selectedSection = section;
                });
              },
            ),
            SectionTile(
              title: 'Approved',
              count: _getLeaveCountByStatus('approved').toString(),
              selectedSection: selectedSection,
              onTap: (section) {
                setState(() {
                  selectedSection = section;
                });
              },
            ),
            SectionTile(
              title: 'Rejected',
              count: _getLeaveCountByStatus('rejected').toString(),
              selectedSection: selectedSection,
              onTap: (section) {
                setState(() {
                  selectedSection = section;
                });
              },
            ),
          ],
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
                  'Leave Summary',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                      fontFamily: 'Roboto'),
                ),
                SizedBox(height: 5),
                Text(
                  'Submit Leave',
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
              AppImages.LeaveImage,
              height: 100,
              width: 100,
            ),
          )
        ],
      ),
    );
  }

  Positioned SummaryContainer(double screenHeight, String paidPeriod,
      LeaveApplicationLoaded state, int usedDays) {
    return Positioned(
      top: screenHeight * 0.15,
      // Adjust to start over Container 1
      left: 0,
      right: 0,
      child: Container(
        height: screenHeight * 0.19,
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
                'Total Leave',
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
                  LeaveStatusTemplate(
                    color: AppColors.darkGreen,
                    label: 'Available',
                    number: state.leaveApplications[0].remainingDays,
                  ),
                  LeaveStatusTemplate(
                    color: AppColors.NavyBlue,
                    label: 'Leave Used',
                    number: usedDays.toString(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
import '../../../Domain/Entities/voucher_entites.dart';
import '../../Activity Dashboard Page/Widget/status_container_template.dart';
import '../../Dashboard Page/Widget/task_card.dart';
import '../../Voucher Creation Page/Page/voucher_creation_UI.dart';
import '../Bloc/voucher_bloc.dart';
import '../Widgets/section_tile.dart';
import '../Widgets/voucher_container.dart';
import '../Widgets/voucher_container_card.dart';
import 'voucher_page_details.dart';

class VoucherDashboard extends StatefulWidget {
  const VoucherDashboard({super.key});

  @override
  State<VoucherDashboard> createState() => _VoucherDashboardState();
}

class _VoucherDashboardState extends State<VoucherDashboard> {
  String selectedSection = 'Review';

  String getPaidPeriodString() {
    // Get today's date
    DateTime today = DateTime.now();

    // Format the start date of the year (1st of January)
    DateTime startDate = DateTime(today.year, 1, 1); // Start of the year
    String startDateFormatted =
        DateFormat('d MMM yyyy').format(startDate); // "1 Jan 2025"

    // Format the end date of the year (31st of December)
    DateTime endDate = DateTime(today.year, 12, 31); // End of the year
    String endDateFormatted =
        DateFormat('d MMM yyyy').format(endDate); // "31 Dec 2025"

    // Return the final formatted string
    return 'Paid Period $startDateFormatted - $endDateFormatted';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<VoucherBloc>(context).add(FetchVouchersEvent());
    });
    // BlocProvider.of<VoucherBloc>(context).add(FetchVouchersEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String paidPeriod = getPaidPeriodString();

    return InternetConnectionChecker(
      child: Scaffold(
        body: BlocListener<VoucherBloc, VoucherState>(
          listener: (context, state) {
            if (state is VoucherError) {
              print('Error: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }
          },
          child: BlocBuilder<VoucherBloc, VoucherState>(
            builder: (context, state) {
              if (state is VoucherLoading) {
                return Center(child: OverlayLoader());
              } else if (state is VoucherLoaded) {
                int _getVoucherCountByStatus(String status) {
                  print('Voucher Status: ${status}');
                  // Filter voucher records by status
                  int count = state.vouchers
                      .where((voucher) =>
                          voucher.status.toLowerCase() ==
                          status.toLowerCase()) // Filter by status
                      .toList()
                      .length;
                  print('Voucher Count: ${count}');
                  return count;
                }

                // Function to get the total amount of vouchers by status for the current year
                double _getVoucherTotalAmountByStatus(String status) {
                  // Get the current year
                  int currentYear = DateTime.now().year;

                  // Filter voucher records by the current year, status, and sum the totalAmount
                  double totalAmount = state.vouchers.where((voucher) {
                    // Parse the createdAt string to DateTime and filter by the current year
                    DateTime createdAt = DateTime.parse(
                        voucher.createdAt); // Parse createdAt to DateTime

                    // Debugging: Print voucher status and createdAt year
                    print(
                        'Voucher Status: ${voucher.status}, CreatedAt Year: ${createdAt.year}');

                    return createdAt.year ==
                            currentYear && // Filter by the current year
                        voucher.status.toLowerCase() ==
                            status.toLowerCase(); // Filter by status
                  }).fold(0.0, (sum, voucher) {
                    // Debugging: Check the totalAmount value before parsing
                    print(
                        'Voucher Total Amount (before parsing): ${voucher.totalAmount}');

                    // Parse totalAmount as a double, defaulting to 0.0 if it's not valid
                    double amount =
                        double.tryParse(voucher.totalAmount ?? '') ?? 0.0;

                    // Debugging: Print the parsed amount
                    print('Parsed Total Amount: $amount');

                    return sum + amount; // Sum the totalAmount
                  });

                  // Return the totalAmount
                  return totalAmount;
                }

                double totalReviewedAmount =
                    _getVoucherTotalAmountByStatus('pending');
                double totalApprovedAmount =
                    _getVoucherTotalAmountByStatus('approved');
                double totalRejectedAmount =
                    _getVoucherTotalAmountByStatus('rejected');

                double totalAmount = totalReviewedAmount + totalApprovedAmount;

                // Filtered vouchers based on the selected status
                List<VoucherEntity> filteredVouchers =
                    state.vouchers.where((voucher) {
                  String mappedStatus = '';
                  if (selectedSection.toLowerCase() == 'review') {
                    mappedStatus = 'pending'; // 'pending' maps to 'review'
                  } else if (selectedSection.toLowerCase() == 'approved') {
                    mappedStatus = 'approved'; // 'approved' maps to 'approved'
                  } else if (selectedSection.toLowerCase() == 'rejected') {
                    mappedStatus = 'rejected'; // 'rejected' maps to 'rejected'
                  }

                  return voucher.status.toLowerCase() ==
                      mappedStatus.toLowerCase();
                }).toList();

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
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.1 + 20),
                              child: Column(
                                children: [
                                  selectionBar(
                                      screenWidth, _getVoucherCountByStatus),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  filteredVouchers.isEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50.0),
                                          child: Center(
                                            child: Text(
                                              'No vouchers available',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textGrey,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        )
                                      : listContainer(filteredVouchers),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Second container (Stacked on top of Container 1 and Container 3)
                        summaryContainer(screenHeight, paidPeriod, totalAmount,
                            totalReviewedAmount, totalApprovedAmount),
                      ],
                    ),
                  ),
                );
              } else if (state is VoucherError) {
                return Center(child: Text('Failed to load vouchers.'));
              }
              return Center(child: Text('No data.'));
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
                        customPageRoute(VoucherCreation()),
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
                      'New Expense',
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
                  currentPage: 'Voucher',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView listContainer(List<VoucherEntity> filteredVouchers) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredVouchers.length,
      // The count of filtered vouchers
      itemBuilder: (context, index) {
        final voucher = filteredVouchers[index];

        // If no vouchers match the filter, display a message
        if (filteredVouchers.isEmpty) {
          return Center(
            child: Text(
              'No vouchers available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        // Parse and format the dates
        DateTime parsedCreatedDate = DateTime.parse(voucher.createdAt);
        DateTime parsedApprovedDate = DateTime.parse(voucher.date);

        String createdDate =
            DateFormat('dd MMMM yyyy').format(parsedCreatedDate);
        String approvedDate =
            DateFormat('dd MMMM yyyy').format(parsedApprovedDate);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the detailed page (replace with your detail page)
                     Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VoucherDetailPage(vouchers: filteredVouchers, initialIndex: index,),
                ),
              );
                },
                child: VoucherContainers(
                  submitDate: createdDate,
                  approvedBy: voucher.approverName ?? 'N/A',
                  approvalDate: approvedDate,
                  project: voucher.ProjectName ?? 'Unknown',
                  expense: voucher.totalAmount ?? 'N/A',
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      },
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
                  'Expense Summary',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                      fontFamily: 'Roboto'),
                ),
                SizedBox(height: 5),
                Text(
                  'Claim your expense here',
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
              AppImages.ExpenseImage,
              height: 100,
              width: 100,
            ),
          )
        ],
      ),
    );
  }

  Positioned summaryContainer(
      double screenHeight,
      String paidPeriod,
      double totalAmount,
      double totalReviewedAmount,
      double totalApprovedAmount) {
    return Positioned(
      top: screenHeight * 0.15,
      // Adjust to start over Container 1
      left: 0,
      right: 0,
      child: Container(
        height: screenHeight * 0.2,
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
                'Total Expense',
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
                  VoucherStatusTemplate(
                    imageAsset: AppImages.VoucherTotalIcon,
                    label: 'Total',
                    number: totalAmount,
                  ),
                  VoucherStatusTemplate(
                    color: AppColors.containerBackgroundYellow,
                    label: 'Review',
                    number: totalReviewedAmount,
                  ),
                  VoucherStatusTemplate(
                    color: AppColors.darkGreen,
                    label: 'Approved',
                    number: totalApprovedAmount,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding selectionBar(
      double screenWidth, int _getVoucherCountByStatus(String status)) {
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
              title: 'Review',
              count: _getVoucherCountByStatus('pending').toString(),
              selectedSection: selectedSection,
              onTap: (section) {
                setState(() {
                  selectedSection = section;
                });
              },
            ),
            SectionTile(
              title: 'Approved',
              count: _getVoucherCountByStatus('approved').toString(),
              selectedSection: selectedSection,
              onTap: (section) {
                setState(() {
                  selectedSection = section;
                });
              },
            ),
            SectionTile(
              title: 'Rejected',
              count: _getVoucherCountByStatus('rejected').toString(),
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
}

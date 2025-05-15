import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Common/Widgets/appbar_model.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/voucher_entites.dart';

class VoucherDetailPage extends StatefulWidget {
  List<VoucherEntity> vouchers;
  int initialIndex;

  VoucherDetailPage({required this.vouchers, required this.initialIndex});

  @override
  State<VoucherDetailPage> createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage> {
  int currentIndex = 0;

  String? _formatDate(dynamic date) {
    try {
      DateTime parsedDate = DateTime.parse(date.toString());
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return date?.toString();
    }
  }

  String getDisplayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Under Review'; // User-friendly name for 'pending'
      case 'approved':
        return 'Approved'; // User-friendly name for 'approved'
      case 'rejected':
        return 'Declined'; // User-friendly name for 'rejected'
      default:
        return 'Unknown Status'; // Default case for unexpected values
    }
  }

  String getDisplayType(String type) {
    switch (type.toLowerCase()) {
      case 'other':
        return 'Others';
      case 'customer':
        return 'Customer';
      case 'supplier':
        return 'Supplier';
      default:
        return 'Unknown Status';
    }
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    print(widget.vouchers.length);

    final voucher = widget.vouchers[currentIndex];

    String? formattedDate = _formatDate(voucher.date);
    String? createdAt = _formatDate(voucher.createdAt);
    String? updatedAt = _formatDate(voucher.updatedAt);
    String displayStatus = getDisplayStatus(voucher.status);
    String displayType = getDisplayStatus(voucher.payeeType);

    return Scaffold(
      appBar: AppBarModel(
        title: 'Voucher Details',
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
                textSize16Darker('Voucher ID'),
                textSize14Lighter('${voucher.id}'),
                SizedBox(height: 10),
                textSize16Darker('Date'),
                textSize14Lighter('${formattedDate ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Project'),
                textSize14Lighter('${voucher.ProjectName ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Payee Type'),
                textSize14Lighter('${voucher.payeeType ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Payee Other Name'),
                textSize14Lighter(displayType),
                SizedBox(height: 10),
                textSize16Darker('Customer Name'),
                textSize14Lighter('${voucher.customerName ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Supplier Name'),
                textSize14Lighter('${voucher.supplierName ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Paid By Name'),
                textSize14Lighter('${voucher.paidByName ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Description'),
                textSize14Lighter('${voucher.description ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Total Amount'),
                textSize14Lighter('${voucher.totalAmount ?? 'N/A'} TK'),
                SizedBox(height: 10),
                textSize16Darker('Purchase Id'),
                textSize14Lighter('${voucher.purchaseId ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Sale Name'),
                textSize14Lighter('${voucher.saleId ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Attachment'),
                textSize14Lighter(
                    '${voucher.attachment != null ? 'Yes' : 'No'}'),
                SizedBox(height: 10),
                textSize16Darker('Approver'),
                textSize14Lighter('${voucher.approverName ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Status'),
                textSize14Lighter(displayStatus),
                SizedBox(height: 10),
                textSize16Darker('Created At'),
                textSize14Lighter('${createdAt ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Updated At'),
                textSize14Lighter('${updatedAt ?? 'N/A'}'),
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
                        'Previous Voucher', // Change the text to "Previous"
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
                      onPressed: currentIndex < widget.vouchers.length - 1
                          ? () {
                              setState(() {
                                currentIndex++;
                              });
                            }
                          : null, // Disable the button if at the last task
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            currentIndex < widget.vouchers.length - 1
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
                        'Next Voucher',
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

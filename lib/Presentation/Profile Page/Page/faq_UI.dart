import 'package:flutter/material.dart';

import '../../../Common/Widgets/appbar_model.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../Widget/text_with_divider.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBarModel(
        title: 'How May I Help You!',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: screenHeight,
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey),
                              hintText: 'Search help',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Frequently Asked Question',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelGrey,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Divider(),
                    TextWithIconAndDivider(
                      text: 'How to add a Voucher ?',
                      onIconPressed: () {
                        print('Add icon pressed');
                      },
                    ),
                    TextWithIconAndDivider(
                      text: 'How to apply a leave application ?',
                      onIconPressed: () {
                        print('Add icon pressed');
                      },
                    ),
                    TextWithIconAndDivider(
                      text: 'How to know the status of your activity ?',
                      onIconPressed: () {
                        print('Add icon pressed');
                      },
                    ),
                    TextWithIconAndDivider(
                      text: 'How to add a activity ?',
                      onIconPressed: () {
                        print('Add icon pressed');
                      },
                    ),
                    TextWithIconAndDivider(
                      text: 'How to check in ?',
                      onIconPressed: () {
                        print('Add icon pressed');
                      },
                    ),
                    TextWithIconAndDivider(
                      text: 'How to know the status of your leave application ?',
                      onIconPressed: () {
                        print('Add icon pressed');
                      },
                    ),
                    TextWithIconAndDivider(
                      text: 'How to know the status of you voucher ?',
                      onIconPressed: () {
                        print('Add icon pressed');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: screenHeight * 0.08,
        // child: BottomNavBar(
        //   containerHeight: screenHeight * 0.08,
        //   currentPage: '',
        // ),
      ),
    );
  }
}

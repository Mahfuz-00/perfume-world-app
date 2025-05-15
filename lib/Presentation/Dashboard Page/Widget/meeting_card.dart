import 'package:flutter/material.dart';

import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class MeetingCard extends StatelessWidget {
  final String meetingHeader;
  final String subtitle2;
  final List<String> images;

  const MeetingCard({
    super.key,
    required this.meetingHeader,
    required this.subtitle2,
    required this.images,
  });

  /*              // Loop through the secondCardData list to create multiple second cards
              Column(
                children: List.generate(secondCardData.length, (index) {
                  var secondCard = secondCardData[index];  // Get the data for the second card
                  return Container(
                    padding: EdgeInsets.zero,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row with circular logo, header, and time spreader
                            Row(
                              children: [
                                // Circular Logo (example)
                                CircleAvatar(
                                  radius: 14,
                                  child: Image.asset('assets/images/meeting_icon.png'),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      secondCard['header2'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          secondCard['subtitle2'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // Row with circular images (people) and button
                            Row(
                              children: [
                                // Stacked Circular Images
                                Stack(
                                  children: [
                                    ...List.generate(
                                      secondCard['images'].length > 3
                                          ? 3
                                          : secondCard['images'].length,
                                          (imgIndex) {
                                        return Positioned(
                                          left: imgIndex * 10.0, // Adjust the overlap
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundImage: NetworkImage(
                                                secondCard['images'][imgIndex]),
                                          ),
                                        );
                                      },
                                    ),
                                    if (secondCard['images'].length > 3)
                                      Positioned(
                                        left: 3 * 10.0,
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.grey[400],
                                          child: Text(
                                            '+',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(width: 5),
                                // Set Reminder Button
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Set Reminder',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),*/

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Card(
        color: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
                width: 1,
                color: AppColors.containerBackgroundGrey300)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row with circular logo, header, and time spreader
              Row(
                children: [
                  // Circular Logo
                  CircleAvatar(
                    radius: 16,
                    child: Image.asset(AppImages.MeetingIcon),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meetingHeader, // Second Header
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDarkBlack,
                            fontFamily: 'Roboto'),
                      ),
                      SizedBox(width: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.timer, // Timer icon
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 5),
                          Text(
                            subtitle2,
                            // Second Subtitle (Time spreader)
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textGrey,
                                fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Row with circular images (people) and button
              Row(
                children: [
                  // Stacked Circular Images
                  Expanded(
                    flex: 4,
                    child: Container(
                      //width: screenWidth * 0.4,
                      height: 40,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Stack(
                        children: [
                          // Show up to 3 images, and the rest will show a "+" sign
                          ...List.generate(
                            images.length > 3 ? 3 : images.length,
                            (index) {
                              return Positioned(
                                left: index * 20.0,
                                // Adjust the overlap by modifying the multiplier
                                child: CircleAvatar(
                                  radius: 15, // Adjust size as needed
                                  backgroundImage: AssetImage(
                                    images[
                                        index], // Replace with your image paths
                                  ),
                                ),
                              );
                            },
                          ),
                          if (images.length > 3)
                            Positioned(
                              left: 5 * 14.0,
                              // Position the text after the 3rd image
                              child: Container(
                                padding: EdgeInsets.all(5),
                                // Add some padding around the text
                                child: Text(
                                  '+${images.length - 3}',
                                  // Display + number of images after 3
                                  style: TextStyle(
                                      color: AppColors.textBlack,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  // Spacing between images and button
                  // Set Reminder Button
                  Expanded(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      // Align the button to the right
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Set Reminder',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textWhite,
                              fontFamily: 'Roboto'),
                        ),
                      ),
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

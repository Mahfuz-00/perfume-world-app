import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';

class TaskCard extends StatefulWidget {
  final String taskHeader;
  final String progress;
  final String priority;

  /* final double progression;*/
  final String date;
  final int commentCount;
  final List<String> images;

  const TaskCard({
    super.key,
    required this.taskHeader,
    /*   required this.progression,*/
    required this.images,
    required this.priority,
    required this.progress,
    required this.date,
    required this.commentCount,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    /*   _progress =
        widget.progression; // Use widget.progression to access the value*/
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String _formatDate(String date) {
      if(date != ''){
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
      } else{
        return 'N/A';
      }
    }

    print('Images :: ${widget.images}');

    String Status = 'N/A';

    if (widget.progress == 'pending' || widget.progress == 'To Do') {
      Status = 'To Do';
    } else if (widget.progress == 'in_progress' || widget.progress == 'In Progress') {
      Status = 'In Progress';
    } else if (widget.progress == 'complete' || widget.progress == 'Finished') {
      Status = 'Finished';
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
              // Row with circular logo, header, and time spreader
              Row(
                children: [
                  // Circular Logo
                  CircleAvatar(
                    radius: 16,
                    child: Image.asset(AppImages.TaskIcon),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.taskHeader == ''? 'N/A': widget.taskHeader, // Second Header
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDarkBlack,
                          fontFamily: 'Roboto'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    //width: screenWidth * 0.30,
                    height: screenHeight * 0.035,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.containerBackgroundGrey300,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.progress == 'Finished'
                            ? Icon(
                                Icons.check, // Checkmark icon
                                size: 16,
                                color: AppColors.primary, // Primary color
                              )
                            : Icon(
                                Icons.timer, // Timer icon
                                size: 16,
                                color: Colors.grey[600],
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          Status,
                          style: TextStyle(
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: 'Roboto'),
                          /*overflow: TextOverflow.ellipsis,
                          maxLines: 1,*/
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    //width: screenWidth * 0.18,
                    height: screenHeight * 0.035,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _getBackgroundColor(
                          widget.priority), // Dynamically set the color
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag_rounded,
                          size: 16,
                          color: AppColors.textWhite,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          _getProgressionText(widget.priority),
                          // Dynamically set the text
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.2,
                  )
                ],
              ),
              SizedBox(height: 8),
              /* InteractiveProgressBar(
                initialProgress: _progress,
                onProgressChanged: (newProgress) {
                  setState(() {
                    _progress = newProgress; // Update progress when changed
                  });
                },
              ),
              SizedBox(height: 8),
              // Row with circular images (people) and button*/
              Container(
                child: Row(
                  children: [
                    // Stacked Circular Images
                    Expanded(
                      flex: 5,
                      child: Container(
                        /*width: screenWidth * 0.4,*/
                        height: 40,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Stack(
                          children: [
                            // Show up to 3 images, and the rest will show a "+" sign
                            ...List.generate(
                              widget.images.length > 3
                                  ? 3
                                  : widget.images.length,
                              (index) {
                                return Positioned(
                                  left: index * 20.0,
                                  // Adjust the overlap by modifying the multiplier
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: widget
                                            .images[index].isEmpty
                                        ? Image.asset(AppImages.HRImage)
                                            .image // Show default image if the URL is empty
                                        : Image.network(
                                            widget.images[index],
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              print('Error loading image');
                                              // Return default image if the URL fails to load
                                              return Image.asset(
                                                  AppImages.HRImage);
                                            },
                                          ).image,
                                  ),
                                );
                              },
                            ),
                            if (widget.images.length > 3)
                              Positioned(
                                left: 5 * 14.0,
                                // Position the text after the 3rd image
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  // Add some padding around the text
                                  child: Text(
                                    '+${widget.images.length - 3}',
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

                    // First container with calendar icon and date
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.textWhite,
                          borderRadius: BorderRadius.circular(4),
                          /*border: Border.all(color: AppColors.textWhite), */ // Adjust border color as needed
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.CalenderIcon,
                              color: Colors.grey,
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(width: 5), // Spacing between icon and text
                            Text(
                              _formatDate(widget.date),
                              style: TextStyle(
                                  color: AppColors.textBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: 'Roboto'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Spacing between first and second container

                    // Second container with comment icon and comment count
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.textWhite,
                          borderRadius: BorderRadius.circular(2),
                          /*border: Border.all(
                              color: Colors.grey),*/ // Adjust border color as needed
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.CommentIcon2,
                              color: Colors.grey,
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(width: 5), // Spacing between icon and text
                            Text(
                              widget.commentCount.toString(),
                              // Replace with your comment count
                              style: TextStyle(
                                  color: AppColors.textBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontFamily: 'Roboto'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getProgressionText(String progression) {
    switch (progression.toLowerCase()) {
      case 'emergency':
        return 'Emergency';
      case 'low':
        return 'Low';
      case 'medium':
        return 'Medium';
      case 'high':
        return 'High';
      default:
        return 'Unknown';
    }
  }

  Color _getBackgroundColor(String progression) {
    switch (progression.toLowerCase()) {
      case 'emergency':
        return AppColors.containerBackgroundRed2; // Define in your AppColors
      case 'low':
        return AppColors.primary; // Define in your AppColors
      case 'medium':
        return AppColors.containerBackgroundYellow; // Define in your AppColors
      case 'high':
        return AppColors.containerBackgroundRed;
      default:
        return Colors.grey; // Default color for unknown progression
    }
  }
}

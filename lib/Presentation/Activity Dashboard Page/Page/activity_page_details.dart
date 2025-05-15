import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Common/Widgets/appbar_model.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/activity_entities.dart';

class TaskDetailPage extends StatefulWidget {
  List<ActivityEntity> tasks;
  int initialIndex;

  TaskDetailPage({required this.tasks, required this.initialIndex});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
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

  List<ActivityEntity> taskList = [
    // Add your tasks here
  ];
  int currentIndex = 0;

  String? startdate;
  String? enddate;
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

    print(widget.tasks.length);

    final task = widget.tasks[currentIndex];

    startdate = _formatDate(task.startDate);
    enddate = _formatDate(task.endDate);

    List<String> Images = task.assignedUsers != null
        ? task.assignedUsers!
            .map((user) => user.profilePhotoPath ?? 'Unknown')
            .toList()
        : [];

    List<String> name = task.assignedUsers != null
        ? task.assignedUsers!.map((user) => user.name ?? 'N/A').toList()
        : [];

    List<int> id = task.assignedUsers != null
        ? task.assignedUsers!.map((user) => user.id ?? 0).toList()
        : [];

    // Assuming task.assignor is the ID to search for
    late final String AssignorEmployee;

// Check if task.assignor is not null and assignedUsers is available
    if (task.assignor != null && task.assignedUsers != null) {
      // Find the user whose id matches task.assignor
      final assignorUser = task.assignedUsers!.firstWhere(
        (user) => user.id == task.assignor,
        // Assuming task.assignor is a string
        orElse: () => AssignedUserEntity(
            id: 0,
            name: 'N/A',
            profilePhotoPath: 'Unknown'), // Default user in case of no match
      );

      // Assign the name to AssignorEmployee
      AssignorEmployee =
          assignorUser.name ?? 'N/A'; // Fallback to 'N/A' if name is null
    }

    String Status = 'N/A';
    if (task.status == 'pending') {
      Status = 'To Do';
    }

    if (task.status == 'in_progress') {
      Status = 'In Progress';
    }

    if (task.status == 'complete') {
      Status = 'Finished';
    }

    String Priority = 'N/A';

    if (task.priority?.toLowerCase() == 'high') {
      Priority = 'High';
    } else if (task.priority?.toLowerCase() == 'medium') {
      Priority = 'Medium';
    } else if (task.priority?.toLowerCase() == 'low') {
      Priority = 'Low';
    }

    return Scaffold(
      appBar: AppBarModel(
        title: '${task.title ?? 'N/A'}',
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
                    Expanded(child: textSize16Darker('${task.title ?? 'N/A'}')),
                  ],
                ),
                SizedBox(height: 20),
                textSize16Darker('Project'),
                textSize14Lighter('${task.projectName ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Start Date'),
                textSize14Lighter('${startdate ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('End Date'),
                textSize14Lighter('${enddate ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Estimated Hours'),
                textSize14Lighter('${task.estimateHours ?? 'N/A'} Hours'),
                SizedBox(height: 10),
                textSize16Darker('Assignor Employee'),
                textSize14Lighter('${AssignorEmployee ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Description'),
                textSize14Lighter('${task.description ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Comment'),
                textSize14Lighter(
                    '${task.comment == '' ? 'N/A' : task.comment}'),
                SizedBox(height: 10),
                textSize16Darker('Priority'),
                textSize14Lighter('${Priority ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Status'),
                textSize14Lighter('${Status ?? 'N/A'}'),
                SizedBox(height: 10),
                textSize16Darker('Assigned Employees'),
                Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Stack(
                    children: [
                      // Show up to 3 images, and the rest will show a "+" sign
                      ...List.generate(
                        /*  Images.length > 3 ? 3 :*/
                        Images.length,
                        (index) {
                          return Positioned(
                            left: index * 20.0,
                            // Adjust the overlap by modifying the multiplier
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: Images[index].isEmpty
                                  ? Image.asset(AppImages.HRImage)
                                      .image // Show default image if the URL is empty
                                  : Image.network(
                                      Images[index],
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print('Error loading image');
                                        // Return default image if the URL fails to load
                                        return Image.asset(AppImages.HRImage);
                                      },
                                    ).image,
                            ),
                          );
                        },
                      ),
                      /*if (Images.length > 3)
                        Positioned(
                          left: 5 * 14.0,
                          // Position the text after the 3rd image
                          child: Container(
                            padding: EdgeInsets.all(5),
                            // Add some padding around the text
                            child: Text(
                              '+${Images.length - 3}',
                              // Display + number of images after 3
                              style: TextStyle(
                                  color: AppColors.textBlack,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                        ),*/

                    ],
                  ),
                ),
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
                      onPressed: currentIndex < widget.tasks.length - 1
                          ? () {
                              setState(() {
                                currentIndex++;
                              });
                            }
                          : null, // Disable the button if at the last task
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentIndex < widget.tasks.length - 1
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
                        'Next Task',
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

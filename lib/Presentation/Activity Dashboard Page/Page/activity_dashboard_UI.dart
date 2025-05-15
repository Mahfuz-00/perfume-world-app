import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Helper/navigation_transition.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/activity_entities.dart';
import '../../Activity Creation Page/Page/activity_creation_UI.dart';
import '../../Dashboard Page/Widget/task_card.dart';
import '../Bloc/activity_bloc.dart';
import '../Bloc/activity_event.dart';
import '../Bloc/activity_state.dart';
import '../Widget/section_tile.dart';
import '../Widget/status_container_template.dart';
import 'activity_page_details.dart';

class ActivityDashboard extends StatefulWidget {
  const ActivityDashboard({super.key});

  @override
  State<ActivityDashboard> createState() => _ActivityDashboardState();
}

class _ActivityDashboardState extends State<ActivityDashboard> {
  String selectedSection = 'All'; // Default to 'All'

  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to ensure the Bloc is ready before adding the event
    /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskBloc = BlocProvider.of<TaskBloc>(context);
      taskBloc.add(LoadTasksEvent()); // Dispatch the event
    });*/

    final taskBloc = BlocProvider.of<ActivityBloc>(context);
    taskBloc.add(LoadActivityEvent()); // Dispatch the event
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetConnectionChecker(
      child: Scaffold(
        body: BlocBuilder<ActivityBloc, ActivityState>(
          builder: (context, state) {
            if (state is ActivityLoadingState) {
              // Show a loading spinner when the tasks are being loaded
              return Center(child: OverlayLoader());
            } else if (state is ActivityLoadedState) {
              final filteredTasks = state.tasks.where((task) {
                print('Selected 1: $selectedSection');
                if (selectedSection == 'All') {
                  return true;
                } else {
                  print('Selected: $selectedSection');
                  String Status = 'N/A';
                  if (task.status == 'pending') {
                    Status = 'To Do';
                  }

                  // Change 'in_progress' to 'In Progress'
                  if (task.status == 'in_progress') {
                    Status = 'In Progress';
                    print('Yay! You');
                  }

                  // Change 'complete' to 'Finished'
                  if (task.status == 'complete') {
                    Status = 'Finished';
                  }

                  print(Status);
                  return selectedSection == Status;
                }
              }).toList();

              return SafeArea(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      // First container (30% of the screen height)
                      Column(
                        children: [
                          designContainer(screenHeight: screenHeight),

                          // Third container (Rest of the body content below Container 1)
                          Container(
                            width: screenWidth,
                            color: AppColors.containerBackgroundGrey300,
                            padding:
                                EdgeInsets.only(top: screenHeight * 0.09 + 20),
                            child: Column(
                              children: [
                                // Second container with task sections
                                selectionBar(screenWidth, state),
                                SizedBox(
                                  height: 20,
                                ),
                                filteredTasks.isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                        // Add padding if no tasks
                                        child: Center(
                                          child: Text(
                                            'No activity available',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textGrey,
                                                fontFamily: 'Roboto'),
                                          ),
                                        ),
                                      )
                                    : listContainer(filteredTasks, state),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Second container (Stacked on top of Container 1 and Container 3)
                      Positioned(
                        top: screenHeight * 0.15,
                        // Adjust to start over Container 1
                        left: 0,
                        right: 0,
                        child: Container(
                          height: screenHeight * 0.18,
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
                                  'Summary of Your Work',
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
                                  'Your current task progress',
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: TaskStatusTemplate(
                                          imageAsset: AppImages.TodoIcon,
                                          label: 'To Do',
                                          // BlocBuilder wraps only the number, not the whole widget
                                          number: state.taskCounts['All']
                                                  ?.toString() ??
                                              '0' /*blocBuilderForCount(
                                            'To Do', AppColors.textBlack),*/
                                          ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: TaskStatusTemplate(
                                        imageAsset: AppImages.InProgressIcon,
                                        label: 'In Progress',
                                        number: state.taskCounts['In Progress']
                                                ?.toString() ??
                                            '0', /*blocBuilderForCount(
                                            'In Progress', AppColors.textBlack),*/
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: TaskStatusTemplate(
                                        imageAsset: AppImages.DoneIcon,
                                        label: 'Done',
                                        number: state.taskCounts['Finished']
                                                ?.toString() ??
                                            '0' /* blocBuilderForCount(
                                            'Finish', AppColors.textBlack)*/
                                        ,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ActivityErrorState) {
              // Show an error message if there's an error while fetching tasks
              return Center(
                child: Text('Error: ${state.errorMessage}'),
              );
            } else {
              // Default state (TaskInitialState), when no data has been loaded yet
              return Center(
                  child: Text(
                'No activities available.',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                    fontFamily: 'Roboto'),
              ));
            }
          },
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
                        customPageRoute(ActivityCreation()),
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
                      'Create Task',
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
                  currentPage: 'Activity',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView listContainer(
      List<ActivityEntity> filteredTasks, ActivityLoadedState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        // Get the task at the current index
        final taskComment = state.tasks[index];

        // Calculate the number of comments for this specific task
        final commentCount = (taskComment.comment?.isNotEmpty ?? false)
            ? taskComment.comment!.split(',').length
            : 0; // If comment is empty, count is 0

        // Print the comment count for the specific task
        print('Task: ${taskComment.title}, Comment Count: $commentCount');

        // Create the filtered list of tasks
        final filteredTasks = state.tasks.where((task) {
          print('Selected 1: $selectedSection');
          if (selectedSection == 'All') {
            return true;
          } else {
            print('Selected: $selectedSection');
            String Status = 'N/A';
            if (task.status == 'pending') {
              Status = 'To Do';
            }

            // Change 'in_progress' to 'In Progress'
            if (task.status == 'in_progress') {
              Status = 'In Progress';
              print('Yay! You');
            }

            // Change 'complete' to 'Finished'
            if (task.status == 'complete') {
              Status = 'Finished';
            }

            print(Status);
            return selectedSection == Status;
          }
        }).toList();

        final task = filteredTasks[index];

        String Status = 'N/A';
        if (task.status == 'pending') {
          Status = 'To Do';
        }

        // Change 'in_progress' to 'In Progress'
        if (task.status == 'in_progress') {
          Status = 'In Progress';
        }

        // Change 'complete' to 'Finished'
        if (task.status == 'complete') {
          Status = 'Finished';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {
              // Navigate to the new page and pass task data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailPage(
                    tasks: filteredTasks,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: TaskCard(
              taskHeader: task.title ?? 'N/A',
              date: task.startDate ?? 'N/A',
              priority: task.priority ?? 'N/A',
              progress: Status ?? 'N/A',
              /*   progression: task.progression,*/
              images: task.assignedUsers != null
                  ? task.assignedUsers!
                      .map((user) => user.profilePhotoPath ?? '')
                      .toList()
                  : [],
              commentCount: commentCount,
            ),
          ),
        );
      },
    );
  }

  Padding selectionBar(double screenWidth, ActivityLoadedState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        //padding: const EdgeInsets.all(16.0),
        width: screenWidth,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SectionTile(
              title: 'All',
              count: state.taskCounts['All']?.toString() ??
                  '0' /*blocBuilderForCount(

                                          'All', AppColors.textBlack)*/
              ,
              selectedSection: selectedSection,
              onTap: (section) {
                setState(() {
                  selectedSection = section;
                });
              },
            ),
            SectionTile(
              title: 'In Progress',
              count: state.taskCounts['In Progress']?.toString() ??
                  '0' /*blocBuilderForCount(
                                          'In Progress', AppColors.textBlack)*/
              ,
              selectedSection: selectedSection,
              onTap: (section) {
                setState(() {
                  selectedSection = section;
                });
              },
            ),
            SectionTile(
              title: 'Finished',
              count: state.taskCounts['Finished']?.toString() ??
                  '0' /*blocBuilderForCount(
                                          'Finish', AppColors.textBlack)*/
              ,
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

  Widget blocBuilderForCount(String section, Color? color) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        // Handle different states based on the TaskBloc
        if (state is ActivityLoadingState) {
          return Text(
            '0',
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
                fontFamily: 'Roboto'),
          ); // Show 0 while loading
        } else if (state is ActivityLoadedState) {
          // Check if the section exists in taskCounts and return the value
          final count = state.taskCounts[section]?.toString() ?? '0';
          return Text(
            count,
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
                fontFamily: 'Roboto'),
          ); // Return the count as text
        } else if (state is ActivityErrorState) {
          return Text(
            '--',
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
                fontFamily: 'Roboto'),
          ); // Show '--' in case of an error
        } else {
          return Text(
            '0',
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
                fontFamily: 'Roboto'),
          ); // Default fallback value
        }
      },
    );
  }
}

class designContainer extends StatelessWidget {
  const designContainer({
    super.key,
    required this.screenHeight,
  });

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
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
                  'Challenges Awaiting',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                      fontFamily: 'Roboto'),
                ),
                SizedBox(height: 5),
                Text(
                  'Let\'s tackle your to-do list',
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
              AppImages.TaskImage,
              height: 100,
              width: 100,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Common/Bloc/project_bloc.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Widgets/appbar_model.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Common/Widgets/drop_down.dart';
import '../../../Common/Widgets/dropdown_object.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Common/Widgets/label_above_datafield.dart';
import '../../../Core/Config/Dependency Injection/injection.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/activity_form_entities.dart';
import '../../Activity Dashboard Page/Page/activity_dashboard_UI.dart';
import '../Bloc/activity_form_bloc.dart';
import '../Widget/date_picker.dart';

class ActivityCreation extends StatefulWidget {
  const ActivityCreation({super.key});

  @override
  State<ActivityCreation> createState() => _ActivityCreationState();
}

class _ActivityCreationState extends State<ActivityCreation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tasktitlecontroller =
      new TextEditingController();
  final TextEditingController _taskdescriptioncontroller =
      new TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _assigntoController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _estimatedHourController =
      TextEditingController();
  String _selectedAssignTo = '';
  String _selectedProject = '';
  String _selectedPriority = '';
  String _selectedStatus = '';
  bool isButtonEnabled = false;

  DateTime? startDate;
  DateTime? endDate;

  List<Map<String, String>> projectOptions = [];

  late ActivityFormBloc _activityFormBloc;

  void _validateForm() {
    print('Task Title: ${_tasktitlecontroller.text}');
    print('Task Description: ${_taskdescriptioncontroller.text}');
    print('Project: ${_projectController.text}');
    print('Start Date: ${_startDateController.text}');
    print('End Date: ${_endDateController.text}');
    print('Estimated Hours: ${_estimatedHourController.text}');
    print('Assigned To: ${_assigntoController.text}');
    print('Priority: ${_priorityController.text}');
    print('Status: ${_statusController.text}');
    print('Button enabled: $isButtonEnabled');

    // Check if any of the fields are empty
    bool areFieldsFilled = _tasktitlecontroller.text.isNotEmpty &&
        _taskdescriptioncontroller.text.isNotEmpty &&
        _startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty &&
        /* _assigntoController.text.isNotEmpty &&*/
        _priorityController.text.isNotEmpty &&
        _projectController.text.isNotEmpty &&
        _estimatedHourController.text.isNotEmpty &&
        _statusController.text.isNotEmpty;

    setState(() {
      isButtonEnabled = areFieldsFilled;
    });
  }

  late int totalHours = 0;

  void calculateEstimatedHours(String startDate, String endDate) {
    try {
      print('Start Date in function: $startDate');
      print('End Date in function: $endDate'); // Parse the start and end dates
      final start = DateFormat('dd-MM-yyyy').parse(startDate);
      final end = DateFormat('dd-MM-yyyy').parse(endDate);

      if (start.isAfter(end)) {
        throw Exception("Start date cannot be after the end date.");
      }

      // Calculate the number of days between the dates (inclusive)
      int differenceInDays = end.difference(start).inDays + 1;

      // Calculate the total estimated hours
      totalHours = differenceInDays * 7;
      setState(() {
        // Store the result in the external variable
        _estimatedHourController.text = '${totalHours.toString()} Hours';
      });
      print("Estimated hours: ${_estimatedHourController.text}");
    } catch (e) {
      print("Error calculating estimated hours: $e");
    }
  }

  // Handle date selection for start and end dates
  void _onStartDateSelected(DateTime selectedDate) {
    setState(() {
      startDate = selectedDate;
    });
  }

  void _onEndDateSelected(DateTime selectedDate) {
    setState(() {
      endDate = selectedDate;
    });
  }

  @override
  void initState() {
    super.initState();
    _activityFormBloc = getIt<ActivityFormBloc>();
    context.read<ProjectBloc>().add(LoadProjects());
    // Adding listeners to the controllers to detect changes
    _tasktitlecontroller.addListener(_validateForm);
    _taskdescriptioncontroller.addListener(_validateForm);
    _startDateController.addListener(_validateForm);
    _endDateController.addListener(_validateForm);
    _assigntoController.addListener(_validateForm);
    _priorityController.addListener(_validateForm);
    _statusController.addListener(_validateForm);
    _startDateController.addListener(() {
      calculateEstimatedHours(
          _startDateController.text, _endDateController.text);
    });

    _endDateController.addListener(() {
      calculateEstimatedHours(
          _startDateController.text, _endDateController.text);
    });
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    _tasktitlecontroller.dispose();
    _taskdescriptioncontroller.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _assigntoController.dispose();
    _priorityController.dispose();
    _statusController.dispose();
    _estimatedHourController.dispose();
    _projectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetConnectionChecker(
      child: Scaffold(
        appBar: AppBarModel(
          title: 'Create a new activity',
        ),
        body: BlocListener<ActivityFormBloc, ActivityFormState>(
          listener: (context, state) {
            print('Current State: $state');
            if (state is ActivityFormLoading) {
              // Show loading indicator
              print('ActivityFormLoading state received');
              Center(child: OverlayLoader());
            } else if (state is ActivityFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Activity Created Successfully!")),
              );
              // Add a delay to ensure SnackBar shows up before navigating
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.push(
                  context,
                  _customPageRoute(ActivityDashboard()),
                );
              });
            } else if (state is ActivityFormFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.error}")),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelWidget(labelText: 'Task Title'),
                          TextFormField(
                            controller: _tasktitlecontroller,
                            // Use the controller
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'Enter task title',
                              labelText: 'Task Title',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.labelGrey,
                              fontFamily: 'Roboto',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a task title';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          LabelWidget(labelText: 'Task Description'),
                          TextFormField(
                            controller: _taskdescriptioncontroller,
                            // Use the controller
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'Enter Task Description',
                              labelText: 'Task Description',
                              alignLabelWithHint: true,
                              // Ensure label stays at the top
                              labelStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.labelGrey,
                              fontFamily: 'Roboto',
                            ),
                            maxLines: 3,
                            // Make the field larger by increasing maxLines
                            minLines: 3,
                            // Set the minimum number of lines to display
                            // floatingLabelBehavior: FloatingLabelBehavior.always, // Ensure the label stays at the top
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a task description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          LabelWidget(labelText: 'Select Time'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DatePickerFormField(
                                controller: _startDateController,
                                label: 'Start Date',
                                onDateSelected: _onStartDateSelected,
                              ),
                              SizedBox(width: 16),
                              DatePickerFormField(
                                controller: _endDateController,
                                label: 'End Date',
                                onDateSelected: _onEndDateSelected,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          LabelWidget(labelText: 'Estimated Time'),
                          TextFormField(
                            controller: _estimatedHourController,
                            readOnly: true,
                            // Use the controller
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'Estimated Hour',
                              labelText: 'Estimated Hour',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.labelGrey,
                              fontFamily: 'Roboto',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Start and end dates for estimated hours';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          LabelWidget(
                            labelText: 'Project Name',
                          ),
                          BlocListener<ProjectBloc, ProjectState>(
                            listener: (context, state) {
                              if (state is ProjectLoaded) {
                                setState(() {
                                  // Map the projects into dropdown options
                                  projectOptions = state.projects
                                      .map((e) => {
                                            'id': e.id.toString(),
                                            'name': e.name.toString(),
                                          })
                                      .toList();
                                });
                              } else if (state is ProjectError) {
                                print('Failed to load project: ${state.error}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to load projects: ${state.error}')),
                                );
                              }
                            },
                            child: BlocBuilder<ProjectBloc, ProjectState>(
                              builder: (context, state) {
                                // Show loading indicator until projects are loaded
                                return Stack(
                                  children: [
                                    // Dropdown widget with pre-fetched data from the bloc
                                    DropdownWithObject(
                                      controller: _projectController,
                                      label: 'Select Project',
                                      hinttext: 'Select Project',
                                      options: projectOptions,
                                      // Options will be fetched from the bloc
                                      selectedValue: _selectedProject,
                                      // The ID of the selected option
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedProject = value!;
                                          _projectController.text = value ?? '';
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a project';
                                        }
                                        return null;
                                      },
                                    ),
                                    // If loading, show the circular progress indicator on top of the dropdown
                                    if (state is ProjectLoading)
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          /*         LabelWidget(labelText: 'Assign To'),
                          Dropdown(
                            controller: _assigntoController,
                            label: 'Select Assign Person',
                            options: ['Sajjad', 'Shihab', 'Munna'],
                            // List of options
                            selectedValue: _selectedAssignTo,
                            onChanged: (value) {
                              setState(() {
                                _selectedAssignTo = value!;
                                _assigntoController.text = value ?? '';
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a person';
                              }
                              return null;
                            },
                            hinttext: 'Select Assign Person',
                          ),
                          SizedBox(
                            height: 16,
                          ),*/
                          LabelWidget(labelText: 'Priority'),
                          Dropdown(
                            controller: _priorityController,
                            label: 'Select Priority',
                            options: ['Low', 'Medium', 'High'],
                            // List of options
                            selectedValue: _selectedPriority,
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value!;
                                _priorityController.text = value ?? '';
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a priority';
                              }
                              return null;
                            },
                            hinttext: 'Select Priority',
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          LabelWidget(labelText: 'Status'),
                          Dropdown(
                            controller: _statusController,
                            label: 'Select Status',
                            options: ['Pending', 'In Progress', 'Complete'],
                            // List of options
                            selectedValue: _selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                                _statusController.text = value ?? '';
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a status';
                              }
                              return null;
                            },
                            hinttext: 'Select Status',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: BlocListener<ActivityFormBloc, ActivityFormState>(
                    listener: (context, state) {
                      if (state is ActivityFormLoading) {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      } else if (state is ActivityFormSuccess) {
                        Navigator.of(context).pop(); // Close loading dialog
                        // Handle success state (e.g., navigate or show success message)
                      } else if (state is ActivityFormFailure) {
                        Navigator.of(context).pop(); // Close loading dialog
                        // Handle error state (e.g., show error message)
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              print("Button pressed!");
                              final statusKey =
                                  convertStatus(_statusController.text);
                              print(
                                  statusKey); // Outputs the corresponding key or empty string for invalid inputs
                              _validateForm();
                              if (_formKey.currentState!.validate()) {
                                final activity = ActivityFromEntity(
                                  title: _tasktitlecontroller.text,
                                  project: _projectController.text,
                                  startDate: _startDateController.text,
                                  endDate: _endDateController.text,
                                  estimatedHour: totalHours,
                                  /* AssignedEmployee: _selectedAssignTo,*/
                                  description: _taskdescriptioncontroller.text,
                                  priority: _priorityController.text,
                                  status: statusKey,
                                );
                                print('SubmitActivityEvent added');
                                try {
                                  final activityFormBloc =
                                      BlocProvider.of<ActivityFormBloc>(
                                          context);
                                  print('ActivityFormBloc retrieved');
                                  activityFormBloc
                                      .add(SubmitActivityEvent(activity));
                                  print('SubmitActivityEvent added');
                                } catch (e) {
                                  print('Error adding SubmitActivityEvent: $e');
                                }
                                print('SubmitActivityEvent added 2');
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isButtonEnabled
                            ? AppColors.primary
                            : AppColors.labelGrey,
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

  String convertStatus(String statusText) {
    switch (statusText) {
      case 'In Progress':
        return 'in_progress';
      case 'Complete':
        return 'complete';
      case 'Pending':
        return 'pending';
      default:
        return ''; // Return an empty string for invalid inputs
    }
  }

  // Define your custom page route with slide transition
  PageRouteBuilder _customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define the slide animation from the left
        const begin = Offset(1.0, 0.0); // Start off-screen on the left
        const end = Offset.zero; // End at the screen center
        const curve = Curves.easeInOut; // Smooth curve

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration:
          Duration(milliseconds: 500), // Duration of the transition
    );
  }
}

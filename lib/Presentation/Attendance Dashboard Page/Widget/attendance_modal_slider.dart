import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Common/Bloc/project_bloc.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Widgets/drop_down.dart';
import '../../../Common/Widgets/dropdown_object.dart';
import '../../../Common/Widgets/label_above_datafield.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/attendance_form_entities.dart';
import '../Bloc/attendance_form_bloc.dart';
import '../Page/attendance_dashboard_UI.dart';

class BottomSlider extends StatefulWidget {
  final bool isModalOpen; // Flag to track the modal state
  final Function(bool)
      onModalStateChanged; // Callback for when modal state changes
  final TextEditingController entrytimeController; // To track entry time
  final TextEditingController locationController; // To track location
  final TextEditingController projectController; // To track project
  final TextEditingController remarkController; // To track remarks

  BottomSlider({
    required this.isModalOpen,
    required this.onModalStateChanged,
    required this.entrytimeController,
    required this.locationController,
    required this.projectController,
    required this.remarkController,
  });

  @override
  _BottomSliderState createState() => _BottomSliderState();
}

class _BottomSliderState extends State<BottomSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool isButtonEnabled = false;
  String _selectedProject = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // GlobalKey to access Overlay 2's size
  final GlobalKey _overlay2Key = GlobalKey();
  double overlay2Height = 0.0; // Initial value for overlay 2 height
  bool isOverlay2HeightRetrieved =
      false; // Flag to check if the size is already retrieved
  // Calculate height for Overlay 3 as 0.2 of screenHeight or overlay2Height
  double overlay3Height = 0.0;

  List<Map<String, String>> projectOptions = [];

  void _validateForm() {
    print('Entry Time: ${widget.entrytimeController.text}');
    print('Location: ${widget.locationController.text}');
    print('Project: ${widget.projectController.text}');
    print('Remark: ${widget.remarkController.text.isNotEmpty}');
    print('Button enabled: $isButtonEnabled');

    // Check if any of the fields are empty
    bool areFieldsFilled = widget.entrytimeController.text.isNotEmpty &&
        widget.projectController.text.isNotEmpty &&
        widget.remarkController.text.isNotEmpty;

    setState(() {
      isButtonEnabled = areFieldsFilled;
    });
  }

  Future<void> _showClockPicker(BuildContext context) async {
    print("Clock picker function invoked");

    // Pick the date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Pick the time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine date and time into one DateTime object
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Format the date and time as desired, e.g., for display
        String formattedDateTime =
            DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);

        // Set the value in the text field
        widget.entrytimeController.text = formattedDateTime;
      }
    }
  }

  // Function to calculate the height of Overlay 2
  void _setOverlay2Height() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        // Ensure the widget is still in the tree
        final renderObject = _overlay2Key.currentContext?.findRenderObject();
        if (renderObject is RenderBox) {
          setState(() {
            overlay2Height = renderObject.size.height; // Access the height
            isOverlay2HeightRetrieved = true; // Mark retrieval as complete
            overlay3Height = overlay2Height - 75;
            print(overlay3Height);
          });
        } else {
          debugPrint("RenderObject is not a RenderBox or is null.");
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(LoadProjects());
    widget.projectController.addListener(_validateForm);
    widget.entrytimeController.addListener(_validateForm);
    widget.remarkController.addListener(_validateForm);

    // Animation setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 300.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animation on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      if (!isOverlay2HeightRetrieved) {
        _setOverlay2Height();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

/*    // Get height of Overlay 2 using _overlay2Key
    final overlay2Height = _overlay2Key.currentContext?.size?.height ?? 0.0;
    print(overlay2Height);

    // Calculate height for Overlay 3 as 0.2 of screenHeight or overlay2Height
    final overlay3Height = overlay2Height > 0.0
        ? overlay2Height * 0.2
        : screenHeight * 0.2;
    print(overlay3Height);*/

    return BlocListener<AttendanceFormBloc, AttendanceFormState>(
      listener: (context, state) {
        print('Current State: $state');
        if (state is AttendanceFormLoading) {
          // Show loading indicator
          print('AttendanceLoading state received');
          Center(child: OverlayLoader());
        } else if (state is AttendanceSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Attendance Submitted Successfully!")),
          );
          // Add a delay to ensure SnackBar shows up before navigating
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.push(
              context,
              _customPageRoute(AttendanceDashboard()),
            );
          });
        } else if (state is AttendanceFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.error}")),
          );
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              //Background color/Overlay 1
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4CA634),
                        // Dark green center
                        Color(0x004CA634),
                        // Semi-transparent green towards the edges
                        Color(0x00000000),
                        // Fully transparent at the edges
                      ],
                      stops: [0.0, 0.7, 1.0],
                      // Controls where each color stop is placed (0% - 100%)
                      begin: Alignment.center,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              //The Modal/Overlay 2
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  key: _overlay2Key,
                  // height: _animation.value,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, -2)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Slider header or drag handle
                            /*Center(
                            child: Container(
                              width: 40.0,
                              height: 5.0,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),*/
                            const SizedBox(height: 50.0),
                            Center(
                                child: Text(
                              'Check In Time',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                            )),
                            const SizedBox(height: 16.0),
                            Center(
                                child: Text(
                              'Please entry this information for your attendance',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                            )),
                            const SizedBox(height: 16.0),
                            LabelWidget(labelText: 'Entry Time'),
                            GestureDetector(
                              onTap: () {
                                // Trigger clock picker or custom action on tap
                                print("Text field tapped");
                                _showClockPicker(context);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: widget.entrytimeController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    hintText: 'Entry Time',
                                    labelText: 'Entry Time',
                                    alignLabelWithHint: true,
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
                                    prefixIcon: Container(
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 8,
                                          top: 14,
                                          bottom: 14),
                                      child: Image.asset(
                                        AppImages.AttendanceClockIcon,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      maxWidth: 48,
                                      maxHeight: 48,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.labelGrey,
                                    fontFamily: 'Roboto',
                                  ),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter leave days';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            LabelWidget(labelText: 'Project'),
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
                                  print(
                                      'Failed to load project: ${state.error}');
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
                                        controller: widget.projectController,
                                        label: 'Select Project',
                                        hinttext: 'Select Project',
                                        options: projectOptions,
                                        // Options will be fetched from the bloc
                                        selectedValue: _selectedProject,
                                        // The ID of the selected option
                                        prefixicon: Container(
                                          padding: EdgeInsets.only(
                                              left: 16,
                                              right: 8,
                                              top: 14,
                                              bottom: 14),
                                          child: Image.asset(
                                            AppImages.AttendanceProjectIcon,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        prefixconstraint: BoxConstraints(
                                          maxWidth: 48,
                                          maxHeight: 48,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedProject = value!;
                                            widget.projectController.text =
                                                value ?? '';
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
                            LabelWidget(labelText: 'Location (Optional)'),
                            TextFormField(
                              controller: widget.locationController,
                              // Use the controller
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  hintText: 'Location',
                                  labelText: 'Location',
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
                                  prefixIcon: Container(
                                    padding: EdgeInsets.only(
                                        left: 16,
                                        right: 8,
                                        top: 14,
                                        bottom: 14),
                                    child: Image.asset(
                                      AppImages.AttendanceLocationIcon,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    maxWidth: 48,
                                    maxHeight: 48,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: AppColors.primary,
                                  )),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter location name';
                                }
                                return null;
                              },
                              /*    onChanged: (value) {
                                // Optionally update the text with "Days" when value changes
                                _leavedaysController.text = '$value Days';
                                _leavedaysController.selection = TextSelection.fromPosition(TextPosition(offset: _leavedaysController.text.length));
                              },*/
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            LabelWidget(labelText: 'Remarks'),
                            TextFormField(
                              controller: widget.remarkController,
                              // Use the controller
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  hintText: 'Remarks',
                                  labelText: 'Remarks',
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
                                  prefixIcon: Container(
                                    padding: EdgeInsets.only(
                                        left: 16,
                                        right: 8,
                                        top: 14,
                                        bottom: 14),
                                    child: Image.asset(
                                      AppImages.AttendanceRemarkIcon,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    maxWidth: 48,
                                    maxHeight: 48,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: AppColors.primary,
                                  )),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter remarks';
                                }
                                return null;
                              },
                              /*    onChanged: (value) {
                                // Optionally update the text with "Days" when value changes
                                _leavedaysController.text = '$value Days';
                                _leavedaysController.selection = TextSelection.fromPosition(TextPosition(offset: _leavedaysController.text.length));
                              },*/
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Center(
                              child: BlocListener<AttendanceFormBloc,
                                  AttendanceFormState>(
                                listener: (context, state) {
                                  if (state is AttendanceFormLoading) {
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
                                  } else if (state is AttendanceSubmitted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Attendance Submitted Successfully!")),
                                    );
                                    // Add a delay to ensure SnackBar shows up before navigating
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      Navigator.push(
                                        context,
                                        _customPageRoute(AttendanceDashboard()),
                                      );
                                    });
                                  } else if (state is AttendanceFormFailure) {
                                    Navigator.of(context)
                                        .pop(); // Close loading dialog
                                    // Handle error state (e.g., show error message)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(state.error)));
                                  }
                                },
                                child: ElevatedButton(
                                  onPressed: isButtonEnabled
                                      ? () {
                                          print("Button pressed!");

                                          _validateForm();

                                          if (_formKey.currentState!
                                              .validate()) {
                                            // Create AttendanceEntity with data from the form
                                            final attendanceForm =
                                                AttendanceFormEntities(
                                                    entryTime: widget
                                                        .entrytimeController
                                                        .text,
                                                    project: widget
                                                        .projectController.text,
                                                    remark: widget
                                                        .remarkController.text);

                                            print(
                                                'CreateAttendanceEvent added');
                                            try {
                                              final attendanceBloc =
                                                  BlocProvider.of<
                                                          AttendanceFormBloc>(
                                                      context);
                                              print('AttendanceBloc retrieved');
                                              attendanceBloc.add(
                                                  CreateAttendanceEvent(
                                                      attendanceForm)); // Dispatching the event
                                              print(
                                                  'CreateAttendanceEvent added');
                                            } catch (e) {
                                              print(
                                                  'Error adding CreateAttendanceEvent: $e');
                                            }
                                            print(
                                                'CreateAttendanceEvent added 2');
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    fixedSize: Size(screenWidth * 0.85, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: const Text(
                                    'Check In',
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
                  ),
                ),
              ),

              // Overlay 3 (Profile Icon Container)
              Positioned(
                left: screenWidth / 2 - 65, // Centering overlay 3
                bottom: overlay3Height,
                child: Material(
                  elevation: 10.0,
                  // Elevation for shadow
                  borderRadius: BorderRadius.circular(20),
                  // Border radius for rounding
                  shadowColor: Colors.black.withOpacity(0.5),
                  // Optional shadow color
                  child: Container(
                    height: 130,
                    width: 130, // Making it square
                    decoration: BoxDecoration(
                      color: AppColors.primary, // Example color
                      borderRadius: BorderRadius.circular(
                          20), // Border radius for rounding
                    ),
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
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

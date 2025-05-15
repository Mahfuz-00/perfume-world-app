import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Common/Bloc/employee_bloc.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Widgets/appbar_model.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Common/Widgets/bottom_navigation_bar_with_swipe.dart';
import '../../../Common/Widgets/drop_down.dart';
import '../../../Common/Widgets/dropdown_object.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Common/Widgets/label_above_datafield.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/leave_form_entities.dart';
import '../../Leave Dashboard Page/Page/leave_dashboard_UI.dart';
import '../../Voucher Creation Page/Widget/single_date_picker.dart';
import '../Bloc/leave_form_bloc.dart';
import '../Widget/phone_textformfield.dart';
import '../Widget/rangedatepicker.dart';

class LeaveCreation extends StatefulWidget {
  const LeaveCreation({super.key});

  @override
  State<LeaveCreation> createState() => _LeaveCreationState();
}

class _LeaveCreationState extends State<LeaveCreation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _leavetypecontroller =
      new TextEditingController();
  final TextEditingController _taskdelegationcontroller =
      new TextEditingController();
  final TextEditingController _leavereasoncontroller =
      new TextEditingController();
  final TextEditingController _leavedurationController =
      TextEditingController();
  final TextEditingController _leavedaysController = TextEditingController();
  final TextEditingController _assigntoController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedLeaveType = '';
  String _selectedTaskDelegation = '';
  String _selectedAssignTo = '';
  bool isButtonEnabled = false;

  DateTime? leaveDurationStart;
  DateTime? leaveDurationEnd;
  String? leavestartday;
  String? leaveendday;

  List<Map<String, String>> assignToOptions = [];

  // Form validation function to enable/disable button
  void _validateForm() {
    print('Leave Category: ${_leavetypecontroller.text}');
    print('Task Delegation: ${_taskdelegationcontroller.text}');
    print('Task Description: ${_leavereasoncontroller.text}');
    print('Leave Duration: ${_leavedurationController.text}');
    print('Assigned To: ${_assigntoController.text}');
    print('Relation: ${_relationController.text}');
    print('Phone: ${_phoneController.text}');
    print('Button enabled: $isButtonEnabled');

    // Check if any of the fields are empty
    bool areFieldsFilled = _leavetypecontroller.text.isNotEmpty &&
        /*_taskdelegationcontroller.text.isNotEmpty &&*/
        _leavereasoncontroller.text.isNotEmpty &&
        _leavedaysController.text.isNotEmpty &&
        totalDays > 0 &&
        /* _relationController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&*/
        _assigntoController.text.isNotEmpty;

    setState(() {
      isButtonEnabled = areFieldsFilled;
    });
  }

  int totalDays = 0;

  // Handle date selection for start and end dates
  void _onLeaveDurationSelected(DateTime startDate, DateTime endDate) {
    setState(() {
      leaveDurationStart = startDate;
      leaveDurationEnd = endDate;

      leaveendday = leaveDurationEnd?.toIso8601String();
      leavestartday = leaveDurationStart?.toIso8601String();

      // Calculate the difference in days
      totalDays = endDate.difference(startDate).inDays + 1;

      // Update the text controller
      _leavedaysController.text = '${totalDays.toString()} days';
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(FetchEmployeesEvent());
    // Adding listeners to the controllers to detect changes
    _leavetypecontroller.addListener(_validateForm);
    _taskdelegationcontroller.addListener(_validateForm);
    _leavereasoncontroller.addListener(_validateForm);
    _leavedurationController.addListener(_validateForm);
    _assigntoController.addListener(_validateForm);
    _relationController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    _taskdelegationcontroller.dispose();
    _leavereasoncontroller.dispose();
    _leavedurationController.dispose();
    _assigntoController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetConnectionChecker(
      child: Scaffold(
        appBar: AppBarModel(
          title: 'Submit Leave',
        ),
        body: BlocListener<LeaveFormBloc, LeaveFormState>(
          listener: (context, state) {
            print('Current State: $state');
            if (state is LeaveFormLoading) {
              // Show loading indicator
              print('LeaveFormLoading state received');
              Center(child: OverlayLoader());
            } else if (state is LeaveFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Leave Submitted Successfully!")),
              );
              // Add a delay to ensure SnackBar shows up before navigating
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.push(
                  context,
                  _customPageRoute(LeaveDashboard()),
                );
              });
            } else if (state is LeaveFormFailure) {
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
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fill Leave Infromation',
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
                            'Information about leave details',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          LabelWidget(labelText: 'Leave Type'),
                          Dropdown(
                            controller: _leavetypecontroller,
                            label: 'Leave Type',
                            options: ['Casual', 'Sick', 'Medical'],
                            // List of options
                            selectedValue: _selectedLeaveType,
                            onChanged: (value) {
                              setState(() {
                                if (value == 'Casual') {
                                  _selectedLeaveType = 'casual_leave';
                                } else if (value == 'Sick') {
                                  _selectedLeaveType = 'sick_leave';
                                } else if (value == 'Medical') {
                                  _selectedLeaveType = 'medical_leave';
                                }

                                _leavetypecontroller.text = _selectedLeaveType;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a type';
                              }
                              return null;
                            },
                            hinttext: 'Select Type',
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          LabelWidget(labelText: 'Leave Duration'),
                          RangeDatePicker(
                            controller: _leavedurationController,
                            label: 'Leave Duration',
                            onDateSelected: _onLeaveDurationSelected,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          LabelWidget(labelText: 'Leave Days'),
                          TextFormField(
                            controller: _leavedaysController,
                            // Use the controller
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'Leave Days',
                              labelText: 'Leave Days',
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
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter leave days';
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
                          /* LabelWidget(labelText: 'Task Delegation'),
                        Dropdown(
                          controller: _taskdelegationcontroller,
                          label: 'Task Delegation',
                          options: ['Personal', 'Sick', 'Official'],
                          // List of options
                          selectedValue: _selectedTaskDelegation,
                          onChanged: (value) {
                            setState(() {
                              _selectedTaskDelegation = value!;
                              _taskdelegationcontroller.text = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          hinttext: 'Select Category',
                        ),
                        SizedBox(
                          height: 16,
                        ),*/
                          LabelWidget(labelText: 'In Absence task assigned to'),
                          BlocListener<EmployeeBloc, EmployeeState>(
                            listener: (context, state) {
                              if (state is EmployeeLoaded) {
                                setState(() {
                                  // Map the employees into dropdown options
                                  assignToOptions = state.employees
                                      .map((e) => {
                                            'id': e.id.toString(),
                                            'name': e.name.toString(),
                                          })
                                      .toList();
                                });
                              } else if (state is EmployeeError) {
                                print(
                                    'Failed to load employee: ${state.error}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to load employees: ${state.error}')),
                                );
                              }
                            },
                            child: BlocBuilder<EmployeeBloc, EmployeeState>(
                              builder: (context, state) {
                                // Show loading indicator until employees are loaded
                                return Stack(
                                  children: [
                                    // Dropdown widget with pre-fetched data from the bloc
                                    DropdownWithObject(
                                      controller: _assigntoController,
                                      label: 'Select Assign Person',
                                      hinttext: 'Select Assign Person',
                                      options: assignToOptions,
                                      selectedValue: _selectedAssignTo,
                                      // The ID of the selected option
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedAssignTo = value!;
                                          final selectedOption = assignToOptions
                                              .firstWhere((option) =>
                                                  option['id'] == value);
                                          _assigntoController.text =
                                              selectedOption['name']!;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a person';
                                        }
                                        return null;
                                      },
                                    ),
                                    // If loading, show the circular progress indicator on top of the dropdown
                                    if (state is EmployeeLoading)
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
                          /* LabelWidget(
                            labelText: 'Emergency Contact During Leave Period'),
                        PhoneNumberInputField(
                          onPhoneChanged: (phone) {
                            setState(() {
                              print('Phone Number: $phone');
                              _phoneController.text = phone;
                            });
                          },
                          onRelationChanged: (relation) {
                            print('Relation: $relation');
                            _relationController.text = relation;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),*/
                          LabelWidget(labelText: 'Leave Reason'),
                          TextFormField(
                            controller: _leavereasoncontroller,
                            // Use the controller
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'Enter Leave Reason',
                              labelText: 'Leave Reason',
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
                                return 'Please enter leave reason';
                              }
                              return null;
                            },
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
                  child: BlocListener<LeaveFormBloc, LeaveFormState>(
                    listener: (context, state) {
                      if (state is LeaveFormLoading) {
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
                      } else if (state is LeaveFormSuccess) {
                        Navigator.of(context).pop(); // Close loading dialog
                        // Handle success state (e.g., navigate or show success message)
                      } else if (state is LeaveFormFailure) {
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

                              _validateForm();
                              if (_formKey.currentState!.validate()) {
                                // Create LeaveFormEntity with data from the form
                                final leaveForm = LeaveFormEntity(
                                  leaveType: _leavetypecontroller.text,
                                  startDate: leavestartday,
                                  endDate: leaveendday,
                                  totaldays: totalDays,
                                  responsiblePersonId: _selectedAssignTo,
                                  reason: _leavereasoncontroller.text,
                                );

                                print('SubmitLeaveFormEvent added');
                                try {
                                  final leaveFormBloc =
                                      BlocProvider.of<LeaveFormBloc>(context);
                                  print('LeaveFormBloc retrieved');
                                  leaveFormBloc
                                      .add(SubmitLeaveFormEvent(leaveForm));
                                  print('SubmitLeaveFormEvent added');
                                } catch (e) {
                                  print(
                                      'Error adding SubmitLeaveFormEvent: $e');
                                }
                                print('SubmitLeaveFormEvent added 2');
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
                        'Submit Leave',
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
                  currentPage: 'Leave',
                ),
              ),
            ],
          ),
        ),
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

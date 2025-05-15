import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Common/Bloc/project_bloc.dart';
import '../../../Common/Helper/dimmed_overlay.dart';
import '../../../Common/Widgets/appbar_model.dart';
import '../../../Common/Widgets/bottom_navigation_bar.dart';
import '../../../Common/Widgets/bottom_navigation_bar_with_swipe.dart';
import '../../../Common/Widgets/drop_down.dart';
import '../../../Common/Widgets/dropdown_object.dart';
import '../../../Common/Widgets/internet_connection_check.dart';
import '../../../Common/Widgets/label_above_datafield.dart';
import '../../../Core/Config/Assets/app_images.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/voucher_form_entities.dart';
import '../../Activity Creation Page/Widget/date_picker.dart';
import '../../Voucher Dashboard Page/Page/voucher_dashboard_UI.dart';
import '../Bloc/voucher_form_bloc.dart';
import '../Widget/custom_border_painter.dart';
import '../Widget/head_of_accounts_and_expense_amount_set.dart';
import '../Widget/single_date_picker.dart';

class VoucherCreation extends StatefulWidget {
  const VoucherCreation({super.key});

  @override
  State<VoucherCreation> createState() => _VoucherCreationState();
}

class _VoucherCreationState extends State<VoucherCreation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _expenseamountcontroller =
      new TextEditingController();
  final TextEditingController _expensedescriptioncontroller =
      new TextEditingController();
  final TextEditingController _voucherDateController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  String _selectedProject = '';
  bool isButtonEnabled = false;
  File? _file = null;
  String? projectId = '0';

  DateTime? transactionDate;

  List<Map<String, String>> projectOptions = [];

  // Form validation function to enable/disable button
  void _validateForm() {
    print('Expense Date: ${_voucherDateController.text}');
    print('Project: ${_projectController.text}');
    print('Expense Data: ${_expenseData}');
    // print('Task Title: ${_expenseamountcontroller.text}');
    print('Voucher Description: ${_expensedescriptioncontroller.text}');
    print('Button enabled: $isButtonEnabled');

    // Check if any of the fields are empty
    bool areFieldsFilled = /*_expenseamountcontroller.text.isNotEmpty &&*/
        _expenseData != null &&
            _expensedescriptioncontroller.text.isNotEmpty &&
            _voucherDateController.text.isNotEmpty &&
            _projectController.text.isNotEmpty;

    setState(() {
      isButtonEnabled = areFieldsFilled;
    });
  }

  // List to store the expenses data
  List<Map<String, String>> _expenseData = [];

  // Variables to hold the extracted account IDs and amounts
  List<String> _accountIds = [];
  List<double> _amounts = [];

  // Callback function to handle the data from ExpenseListWidget
  void _handleExpenseData(List<Map<String, String>> expenseList) {
    setState(() {
      _expenseData = expenseList;
      print('Expense Data: ${_expenseData}');

      // Extract account IDs and amounts
      _accountIds = _expenseData
          .map((expense) => expense['headOfAccountId'] ?? '')
          .toList();
      // Extract amounts as double
      _amounts = _expenseData.map((expense) {
        // Extract the numeric part by removing 'TK' and trim any extra spaces
        String amountStr =
            expense['amount']?.replaceAll('TK', '').trim() ?? '0';

        // Try to parse the amount into a double
        return double.tryParse(amountStr) ?? 0.0;
      }).toList();

      print('Account IDs: $_accountIds');
      print('Amounts: $_amounts');
    });
  }

  // Handle date selection for start and end dates
  void _onTransactionDateSelected(DateTime selectedDate) {
    setState(() {
      // Format the selectedDate to a string in the desired format
      String formattedDate = DateFormat("dd-MM-yyyy").format(selectedDate);

      // Now parse the formatted string back into a DateTime object
      transactionDate = DateFormat("dd-MM-yyyy").parse(formattedDate);

      // Print the DateTime object after parsing
      print("Transaction Date (DateTime): $transactionDate");
    });
  }

  bool _isLoading = false; // To track loading state

  Future<void> _pickFile() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Trigger the file picker dialog
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpeg',
        'png',
        'jpg',
        'doc',
        'docx',
        'xls',
        'xlsx'
      ], // Allowed file extensions
    );

    setState(() {
      _isLoading = false; // Hide loading indicator after file is picked
    });

    // Check if a file was picked
    if (result != null) {
      // Get the file path and file size
      String? filePath = result.files.single.path;
      int? fileSize = result.files.single.size;

      if (filePath != null && fileSize != null && fileSize <= 5 * 1024 * 1024) {
        // Check if file size is <= 5 MB
        // File picked successfully and size is valid
        _file = File(filePath); // Convert the file path to a File object
        // No need for setState here, file is already picked and _file is updated
        print("File selected: $filePath");
        // Implement your file upload logic here (e.g., upload to a server)
      } else {
        // If the file size exceeds 5 MB
        const snackBar = SnackBar(
          content: Text('File size exceeds 5 MB'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print("File size exceeds 5 MB");
      }
    } else {
      const snackBar = SnackBar(
        content: Text('File picking canceled'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // User canceled the picker
      print("File picking canceled");
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(LoadProjects());
    // Adding listeners to the controllers to detect changes
    _expenseamountcontroller.addListener(_validateForm);
    _expensedescriptioncontroller.addListener(_validateForm);
    _voucherDateController.addListener(_validateForm);
    _projectController.addListener(_validateForm);
  }

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    _expenseamountcontroller.dispose();
    _expensedescriptioncontroller.dispose();
    _voucherDateController.dispose();
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
          title: 'Submit Expense',
        ),
        body: BlocListener<VoucherFormBloc, VoucherFormState>(
          listener: (context, state) {
            print('Current State: $state');
            if (state is VoucherFormLoading) {
              // Show loading indicator
              print('VoucherFormLoading state received');
              Center(child: OverlayLoader());
            } else if (state is VoucherFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Voucher Created Successfully!")),
              );
              // Add a delay to ensure SnackBar shows up before navigating
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.push(
                  context,
                  _customPageRoute(VoucherDashboard()),
                );
              });
            } else if (state is VoucherFormFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.error}")),
              );
            }
          },
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Fill Claim Infromation',
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
                            'Information about claim details',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.labelGrey,
                                fontFamily: 'Roboto'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          LabelWidget(labelText: 'Voucher Date'),
                          SingleDatePicker(
                            controller: _voucherDateController,
                            label: 'Voucher Date',
                            onDateSelected: _onTransactionDateSelected,
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
                          ExpenseListWidget(
                            onExpenseAdded: _handleExpenseData,
                          ),
                          /*       LabelWidget(labelText: 'Expense Amount'),
                        TextFormField(
                          controller: _expenseamountcontroller,
                          // Use the controller
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'Enter expense amount',
                              labelText: 'Expense Amount',
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
                              suffixIcon: Icon(
                                Icons.add,
                                color: AppColors.primary,
                                size: 24,
                              )),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.labelGrey,
                            fontFamily: 'Roboto',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your expense amount';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),*/
                          LabelWidget(labelText: 'Expense Description'),
                          TextFormField(
                            controller: _expensedescriptioncontroller,
                            // Use the controller
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'Enter Expense Description',
                              labelText: 'Expense Description',
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
                                return 'Please enter a expense description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: _pickFile,
                              child: Container(
                                height: 120,
                                width: screenWidth * 0.9,
                                decoration: BoxDecoration(
                                  color: _file != null
                                      ? AppColors.primary
                                      : AppColors.containerBackgroundPurple,
                                  // Change color when file is selected
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CustomPaint(
                                    painter: DashedBorderPainter(),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (_isLoading != true) ...[
                                          Image.asset(
                                            AppImages.VoucherFileUploadIcon,
                                            height: 30,
                                            width: 30,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            _file != null
                                                ? "Claim Document Uploaded"
                                                : "Upload Claim Document",
                                            // Change text when file is selected
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: _file != null
                                                  ? AppColors
                                                      .containerBackgroundPurple
                                                  : AppColors.primary,
                                              // Reverse text color
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          if (_file == null) ...[
                                            Text(
                                              "Format should be in .pdf, .jpeg, .png less than 5 MB",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.labelGrey,
                                                // Reverse text color
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ] else if (_isLoading == true) ...[
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator(), // The loading spinner
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: BlocListener<VoucherFormBloc, VoucherFormState>(
                    listener: (context, state) {
                      if (state is VoucherFormLoading) {
                        // Trigger loading state logic, like showing a loading indicator
                        // You can show a loading indicator here using a dialog or another method
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return OverlayLoader();
                          },
                        );
                      } else if (state is VoucherFormSuccess) {
                        Navigator.of(context).pop(); // Close the loading dialog
                        // Handle success state
                      } else if (state is VoucherFormFailure) {
                        Navigator.of(context).pop(); // Close the loading dialog
                        // Handle error state
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                final voucherFormEntity = VoucherFormEntity(
                                  date: transactionDate,
                                  costCenterId: projectId,
                                  description:
                                      _expensedescriptioncontroller.text,
                                  accountIds: _accountIds,
                                  // This should be a list of selected account IDs
                                  amounts: _amounts,
                                  // This should be a list of amounts
                                  attachment: _file,
                                  paidStatus: 'pending',
                                );

                                print('SubmitVoucherFormEvent added');
                                try {
                                  final voucherFormBloc =
                                      BlocProvider.of<VoucherFormBloc>(context);
                                  print('VoucherFormBloc retrieved');
                                  voucherFormBloc.add(SubmitVoucherFormEvent(
                                      voucherFormEntity));
                                  print('SubmitVoucherFormEvent added');
                                } catch (e) {
                                  print(
                                      'Error adding SubmitVoucherFormEvent: $e');
                                }
                                print('SubmitVoucherFormEvent added 2');
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
                        'Submit Expense',
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
                  currentPage: 'Voucher',
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

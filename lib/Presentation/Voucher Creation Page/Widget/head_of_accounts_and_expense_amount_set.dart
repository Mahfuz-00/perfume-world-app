import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Common/Widgets/dropdown_object.dart';
import '../../../Common/Widgets/label_above_datafield.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../Bloc/headofaccounts_bloc.dart';

class ExpenseListWidget extends StatefulWidget {
  // Add a callback to pass the data to the parent widget
  final Function(List<Map<String, String>>) onExpenseAdded;

  ExpenseListWidget({required this.onExpenseAdded});

  @override
  _ExpenseListWidgetState createState() => _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends State<ExpenseListWidget> {
  final List<Map<String, String>> _expenseList = []; // Store each set of fields
  final TextEditingController _headOfAccountController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool isButtonEnabled = false;
  String _selectedAssignTo = '';

  List<Map<String, String>> headOfAccountsOptions = [];

  // Add a new entry to the list
  void _addExpense() {
    setState(() {
      if (_amountController.text == '') _amountController.text = '0';
      _expenseList.add({
        'headOfAccountId': _selectedAssignTo,
        'headOfAccount': _headOfAccountController.text,
        'amount': '${_amountController.text} TK',
      });

      // Send data to parent widget using the callback
      widget.onExpenseAdded(_expenseList);

      setState(() {
        // Clear the controllers for the next entry
        _headOfAccountController.clear();
        _amountController.clear();
        _selectedAssignTo = '';
        print(_headOfAccountController.text);
        print(_amountController.text);
      });
    });
  }

  // Check if both fields are filled
  void _checkFields() {
    setState(() {
      if (_headOfAccountController.text.isNotEmpty &&
          _amountController.text.isNotEmpty) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ExpenseHeadBloc>().add(FetchExpenseHeadsEvent());
    // Add listeners to both controllers
    _headOfAccountController.addListener(_checkFields);
    _amountController.addListener(_checkFields);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Loop through the expenseList to display the fields
        ..._expenseList.map((expense) {
          return Column(
            children: [
              AccountAmountRow(
                headOfAccountController:
                    TextEditingController(text: expense['headOfAccount']),
                amountController:
                    TextEditingController(text: expense['amount']),
              ),
              SizedBox(height: 16),
            ],
          );
        }).toList(),

        // Form fields for adding a new pair
        LabelWidget(labelText: 'Head of Account'),
        BlocListener<ExpenseHeadBloc, ExpenseHeadState>(
          listener: (context, state) {
            if (state is ExpenseHeadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: BlocBuilder<ExpenseHeadBloc, ExpenseHeadState>(
            builder: (context, state) {
              final assignToOptions = state is ExpenseHeadLoaded
                  ? state.expenseHeads
                      .map<Map<String, Object>>((expenseHead) => {
                            'id': expenseHead.id
                                as Object, // Explicitly cast as Object
                            'name': expenseHead.name
                                as Object, // Explicitly cast as Object
                          })
                      .toList()
                  : <Map<String, Object>>[];

              return Stack(
                children: [
                  // Dropdown Widget
                  DropdownWithObject(
                    controller: _headOfAccountController,
                    label: 'Select Head of Account',
                    hinttext: 'Select Head of Account',
                    options: assignToOptions,
                    selectedValue: _selectedAssignTo,
                    onChanged: (value) {
                      setState(() {
                        _selectedAssignTo = value!;
                        final selectedOption = assignToOptions.firstWhere(
                          (option) => option['id'] == value,
                        );
                        _headOfAccountController.text =
                            selectedOption['name']! as String;
                      });
                    },
                    validator: (value) {
                      if (_expenseList.isNotEmpty) return null;
                      if (value == null || value.isEmpty) {
                        return 'Please select a head of account';
                      }
                      return null;
                    },
                  ),
                  // CircularProgressIndicator
                  if (state is ExpenseHeadLoading)
                    Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        /* TextFormField(
          controller: _headOfAccountController,

          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            hintText: 'Enter head of account',
            labelText: 'Head of Account',
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
              return 'Please enter the head of account';
            }
            return null;
          },
        ),*/
        SizedBox(height: 16),
        LabelWidget(labelText: 'Amount'),
        TextFormField(
          controller: _amountController,
          onChanged: (_) => _checkFields(),
          keyboardType: TextInputType.phone,
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
            // Ignore validation if the expense list is not empty
            if (_expenseList.isNotEmpty) {
              return null; // Skip validation
            }

            // Otherwise, perform validation
            if (value == null || value.isEmpty) {
              return 'Please enter your expense amount';
            }
            return null;
          },
        ),
        SizedBox(height: 16),

        // Add button to add a new expense pair
        ElevatedButton(
          onPressed: _addExpense,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isButtonEnabled ? AppColors.primary : AppColors.labelGrey,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            fixedSize: Size(screenWidth * 0.9, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Text(
            'Add Expense',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class AccountAmountRow extends StatelessWidget {
  final TextEditingController headOfAccountController;
  final TextEditingController amountController;

  AccountAmountRow({
    required this.headOfAccountController,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelWidget(labelText: 'Head of Account'),
                TextFormField(
                  controller: headOfAccountController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    hintText: 'Enter head of account',
                    labelText: 'Head of Account',
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
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelWidget(labelText: 'Amount'),
                TextFormField(
                  controller: amountController,
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

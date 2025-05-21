import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Common/Models/cart_model.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/Collection_entities.dart';
import '../Bloc/invoice_bloc.dart';
import '../Bloc/invoice_event.dart';
import '../Bloc/invoice_state.dart';

class InvoiceSubmitDialog extends StatefulWidget {
  final dynamic customer;
  final double totalPrice;
  final String invoiceNumber;
  final List<CartItem> cartItems;

  const InvoiceSubmitDialog({
    super.key,
    required this.customer,
    required this.totalPrice,
    required this.invoiceNumber,
    required this.cartItems,
  });

  @override
  _InvoiceSubmitDialogState createState() => _InvoiceSubmitDialogState();
}

class _InvoiceSubmitDialogState extends State<InvoiceSubmitDialog> {
  String? _selectedPaymentMethod;
  final TextEditingController _collectedAmountController = TextEditingController();
  final TextEditingController _checkNoController = TextEditingController();
  final TextEditingController _refNoController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _cashMemoController = TextEditingController();
  DateTime _checkDate = DateTime.now();

  @override
  void dispose() {
    _collectedAmountController.dispose();
    _checkNoController.dispose();
    _refNoController.dispose();
    _remarkController.dispose();
    _cashMemoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return BlocConsumer<InvoiceBloc, InvoiceState>(
      listener: (context, state) {
        if (state is CollectionSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.primary, duration: const Duration(seconds: 2)));
          Navigator.pop(context);
        } else if (state is InvoiceError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red, duration: const Duration(seconds: 3)));
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: screenWidth * 0.7,
            padding: EdgeInsets.all(64),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Confirm Invoice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Customer Name: ${widget.customer != null ? widget.customer.name : 'No customer selected'}',
                              style: TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh)),
                          SizedBox(height: 8),
                          Text('Previous Due: ${widget.customer != null ? widget.customer.previousDue : 'Due Missing'}', style: TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh)),
                          SizedBox(height: 8),
                          Text('Total: ৳${widget.totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh)),
                          SizedBox(height: 8),
                        ],
                      ),
                      SizedBox(width: 192),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Text('Invoice Number: ${widget.invoiceNumber}', style: TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh)),
                        SizedBox(height: 8),
                        Text('Date: ${DateFormat('MM/dd/yyyy').format(DateTime.now())}', style: TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh)),
                        SizedBox(height: 8),
                      ],)
                    ],
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: TextField(
                      controller: _cashMemoController,
                      decoration: InputDecoration(
                        labelText: 'Cash Memo No.',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: TextField(
                      controller: _collectedAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Collected Amount (৳)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Payment Method', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                      value: _selectedPaymentMethod,
                      items: ['Cash', 'Card', 'Mobile Payment', 'Bank']
                          .map((method) => DropdownMenuItem(value: method, child: Text(method, style: TextStyle(fontSize: 14, fontFamily: 'Roboto'))))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a payment method' : null,
                    ),
                  ),
                  if (_selectedPaymentMethod == 'Bank') ...[
                    SizedBox(height: 8),
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: TextField(
                        controller: _checkNoController,
                        decoration: InputDecoration(
                          labelText: 'Check No.',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          isDense: true,
                        ),
                        style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(context: context, initialDate: _checkDate, firstDate: DateTime(2000), lastDate: DateTime(2030));
                          if (pickedDate != null) {
                            setState(() {
                              _checkDate = pickedDate;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(labelText: 'Check Date', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), isDense: true),
                          child: Text(DateFormat('MM/dd/yyyy').format(_checkDate), style: TextStyle(fontSize: 14, fontFamily: 'Roboto')),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: TextField(
                      controller: _refNoController,
                      decoration: InputDecoration(
                        labelText: 'Ref No.',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: TextField(
                      controller: _remarkController,
                      decoration: InputDecoration(
                        labelText: 'Remark',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: AppColors.textAsh)),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedPaymentMethod != null && _collectedAmountController.text.isNotEmpty) {
                            final collection = Collection(
                              customerId: widget.customer?.id.toString(),
                              prevDues: widget.customer.previousDue.toString(),
                              invoiceNo: widget.invoiceNumber,
                              cashmemoNo: _cashMemoController.text.isNotEmpty ? _cashMemoController.text : null,
                              collectionDate: currentDate,
                              paymentMethod: _selectedPaymentMethod,
                              collectedAmount: _collectedAmountController.text,
                            );
                            context.read<InvoiceBloc>().add(SubmitCollectionEvent(collection));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select a payment method and enter collected amount',
                                    style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: AppColors.backgroundWhite)),
                                backgroundColor: AppColors.primary,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Print', style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: AppColors.backgroundWhite)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
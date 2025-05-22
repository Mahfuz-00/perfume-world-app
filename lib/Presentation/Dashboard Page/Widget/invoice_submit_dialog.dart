// lib/presentation/screens/invoice_submit_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../Common/Models/cart_model.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/Collection_entities.dart';
import '../Bloc/invoice_bloc.dart';
import '../Bloc/invoice_event.dart';
import '../Bloc/invoice_print_bloc.dart';
import '../Bloc/invoice_print_event.dart';
import '../Bloc/invoice_state.dart';
import '../Bloc/payment_bloc.dart';
import '../Bloc/payment_state.dart';
import 'zcspos.dart';


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
  String? _selectedPaymentMethodSlug;
  String? _selectedPaymentMethodName;
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
    print('Customer ID: ${widget.customer?.id}');

    final screenWidth = MediaQuery.of(context).size.width;
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return BlocConsumer<InvoiceBloc, InvoiceState>(
      listener: (context, state) async {
        print('InvoiceBloc State: $state');
        if (state is CollectionSubmitted) {
          print('Payment: $_selectedPaymentMethodName');
          print('Dispatching UpdatePrintData: '
              'slug=$_selectedPaymentMethodSlug, '
              'name=$_selectedPaymentMethodName, '
              'amount=${_collectedAmountController.text}');
          context.read<InvoicePrintBloc>().add(UpdatePrintData(
            paymentMethod: _selectedPaymentMethodName,
            collectedAmount: _collectedAmountController.text,
            checkNo: _checkNoController.text.isNotEmpty ? _checkNoController.text : null,
            checkDate: _checkDate,
            refNo: _refNoController.text.isNotEmpty ? _refNoController.text : null,
            remark: _remarkController.text.isNotEmpty ? _remarkController.text : null,
            cashMemoNo: _cashMemoController.text.isNotEmpty ? _cashMemoController.text : null,
          ));
          Future.microtask(() async {
            final printState = context.read<InvoicePrintBloc>().state;
            print('Print State before ZCSPosSdk: ${printState.toJson()}');
            final success = await ZCSPosSdk.printInvoice(context, printState);
            if (success) {
              context.read<InvoicePrintBloc>().add(ClearPrintData());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Printed successfully'),
                  backgroundColor: AppColors.primary,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to print'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
            Navigator.pop(context);
          });
        } else if (state is InvoiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: screenWidth * 0.7,
            padding: const EdgeInsets.all(64),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Confirm Invoice',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Roboto'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Name: ${widget.customer != null ? widget.customer.name : 'No customer selected'}',
                            style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Previous Due: ${widget.customer != null ? widget.customer.previousDue : 'Due Missing'}',
                            style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total: ৳${widget.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      const SizedBox(width: 192),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Invoice Number: ${widget.invoiceNumber}',
                            style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Date: ${DateFormat('MM/dd/yyyy').format(DateTime.now())}',
                            style: const TextStyle(fontSize: 16, fontFamily: 'Roboto', color: AppColors.textAsh),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: TextField(
                      controller: _cashMemoController,
                      decoration: InputDecoration(
                        labelText: 'Cash Memo No.',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                      style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
                      builder: (context, state) {
                        if (state is PaymentMethodLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is PaymentMethodLoaded) {
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Payment Method',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            value: _selectedPaymentMethodSlug,
                            items: state.paymentMethods
                                .map((method) => DropdownMenuItem(
                              value: method.slug,
                              child: Text(method.name, style: const TextStyle(fontSize: 14, fontFamily: 'Roboto')),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethodSlug = value;
                                _selectedPaymentMethodName = state.paymentMethods
                                    .firstWhere((method) => method.slug == value)
                                    .name;
                                print('Selected: slug=$value, name=$_selectedPaymentMethodName');
                              });
                            },
                            validator: (value) => value == null ? 'Please select a payment method' : null,
                          );
                        } else if (state is PaymentMethodError) {
                          return Text('Error: ${state.message}', style: const TextStyle(color: Colors.red));
                        }
                        return const Text('No payment methods available');
                      },
                    ),
                  ),
                  if (_selectedPaymentMethodSlug == 'bank') ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: TextField(
                        controller: _checkNoController,
                        decoration: InputDecoration(
                          labelText: 'Check No.',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _checkDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2030),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _checkDate = pickedDate;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Check Date',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            isDense: true,
                          ),
                          child: Text(
                            DateFormat('MM/dd/yyyy').format(_checkDate),
                            style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: TextField(
                      controller: _refNoController,
                      decoration: InputDecoration(
                        labelText: 'Ref No.',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: TextField(
                      controller: _remarkController,
                      decoration: InputDecoration(
                        labelText: 'Remark',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: AppColors.textAsh),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedPaymentMethodSlug != null && _collectedAmountController.text.isNotEmpty) {
                            final collection = Collection(
                              customerId: widget.customer?.id.toString(),
                              prevDues: widget.customer?.previousDue.toString() ?? '0',
                              invoiceNo: widget.invoiceNumber,
                              cashmemoNo: _cashMemoController.text.isNotEmpty ? _cashMemoController.text : null,
                              collectedAmount: _collectedAmountController.text,
                              collectionDate: currentDate,
                              paymentMethod: _selectedPaymentMethodSlug,
                              invoiceCollected: _collectedAmountController.text,
                              invoiceDue: widget.totalPrice.toString(),
                              chequeNo: _checkNoController.text.isNotEmpty ? _checkNoController.text : null,
                              chequeDate: _checkDate.toString(),
                              refNo: _refNoController.text.isNotEmpty ? _refNoController.text : null,
                              remarks: _remarkController.text.isNotEmpty ? _remarkController.text : null,
                            );
                            print('Collection: ${collection.toJson()}');
                            context.read<InvoiceBloc>().add(SubmitCollectionEvent(collection));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Please select a payment method and enter collected amount',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    color: AppColors.backgroundWhite,
                                  ),
                                ),
                                backgroundColor: AppColors.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'Print',
                          style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: AppColors.backgroundWhite),
                        ),
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
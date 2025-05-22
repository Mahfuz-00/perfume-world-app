import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/cart_bloc.dart';
import '../Bloc/customer_bloc.dart';
import '../Bloc/customer_event.dart';
import '../Bloc/invoice_bloc.dart';
import '../Bloc/invoice_event.dart';
import '../Bloc/invoice_print_bloc.dart';
import '../Bloc/invoice_print_event.dart';
import '../Bloc/invoice_print_state.dart';
import '../Bloc/payment_bloc.dart';
import '../Bloc/payment_event.dart';

class ZCSPosSdk {
  static const MethodChannel _channel = MethodChannel('ZCSPOSSDK');

  static Future<void> initSdk(BuildContext context) async {
    try {
      await _channel.invokeMethod('initializeSdk');
    } on PlatformException catch (e) {
      print("Failed to initialize SDK: '${e.message}'.");
    }
  }

  static Future<bool> printInvoice(BuildContext context, InvoicePrintState state) async {
    try {
      print('State sending data for printing: ${state.toJson()}');
      final result = await _channel.invokeMethod('printInvoice', state.toJson());
      if (result == "paper_out") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Printer is out of paper'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return false;
      }
      if (result == "printer_error") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Printer error, please check device'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return false;
      }
      if (result == true) {
        // Clear all states after successful print
        context.read<InvoiceBloc>().add(ClearPrintDataEvent());
        context.read<CartBloc>().add(ClearCartEvent());
        context.read<CustomerBloc>().add(ClearCustomerEvent());
        context.read<InvoicePrintBloc>().add(ClearPrintData());
        context.read<PaymentMethodBloc>().add(ClearPaymentMethodEvent());
        print('All states cleared after successful print');
      }
      return result == true;
    } catch (e) {
      print("Failed to print invoice: $e");
      return false;
    }
  }
}
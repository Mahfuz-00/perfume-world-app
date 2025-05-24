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
  static bool _isChannelInitialized = false;

  static Future<void> initSdk(BuildContext context) async {
    try {
      await _channel.invokeMethod('initializeSdk');
    } on PlatformException catch (e) {
      print("Failed to initialize SDK: '${e.message}'.");
    }
  }

  static void initChannel(BuildContext context) {
    if (!_isChannelInitialized) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'showError') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(call.arguments as String),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return null;
      });
      _isChannelInitialized = true;
    }
  }

  static Future<bool> printInvoice(BuildContext context, InvoicePrintState state) async {
    initChannel(context);

    // Clear all states after successful print
    context.read<InvoiceBloc>().add(ClearPrintDataEvent());
    context.read<CartBloc>().add(ClearCartEvent());
    context.read<CustomerBloc>().add(ClearCustomerEvent());
    context.read<InvoicePrintBloc>().add(ClearPrintData());
    context.read<PaymentMethodBloc>().add(ClearPaymentMethodEvent());

    try {
      print('State sending data for printing: ${state.toJson()}');
      final result = await _channel.invokeMethod('printInvoice', state.toJson());
      if (state.toJson()['imagePath'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No imagePath provided in print data'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
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
      if (result == "data_error") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid print data, please check invoice details'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
        return false;
      }
      if (result == "false") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Print failed: Check printer or data'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
        return false;
      }
      if (result == true) {
        // Clear all states after successful print
        // context.read<InvoiceBloc>().add(ClearPrintDataEvent());
        // context.read<CartBloc>().add(ClearCartEvent());
        // context.read<CustomerBloc>().add(ClearCustomerEvent());
        // context.read<InvoicePrintBloc>().add(ClearPrintData());
        // context.read<PaymentMethodBloc>().add(ClearPaymentMethodEvent());
        print('All states cleared after successful print');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Printed successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return result == true;
    } catch (e, stackTrace) {
      print('PrintInvoice error: $e\nStackTrace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to print: $e, $stackTrace'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
      return false;
    }
  }
}
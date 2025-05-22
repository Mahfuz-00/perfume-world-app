import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../Common/Models/cart_model.dart';
import '../../../Domain/Entities/customer_entities.dart';


class InvoicePrintEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializePrintData extends InvoicePrintEvent {
  final Customer? customer;
  final double totalPrice;
  final String invoiceNumber;
  final List<CartItem> cartItems;
  final Map<CartItem, double> itemDiscounts;
  final String vat;
  final String invoiceDiscount;
  final String shipping;

  InitializePrintData({
    required this.customer,
    required this.totalPrice,
    required this.invoiceNumber,
    required this.cartItems,
    required this.itemDiscounts,
    required this.vat,
    required this.invoiceDiscount,
    required this.shipping,
  });

  @override
  List<Object?> get props => [
    customer,
    totalPrice,
    invoiceNumber,
    cartItems,
    itemDiscounts,
    vat,
    invoiceDiscount,
    shipping,
  ];
}

class UpdatePrintData extends InvoicePrintEvent {
  final String? paymentMethod;
  final String? collectedAmount;
  final String? checkNo;
  final DateTime? checkDate;
  final String? refNo;
  final String? remark;
  final String? cashMemoNo;

  UpdatePrintData({
    this.paymentMethod,
    this.collectedAmount,
    this.checkNo,
    this.checkDate,
    this.refNo,
    this.remark,
    this.cashMemoNo,
  });

  @override
  List<Object?> get props => [
    paymentMethod,
    collectedAmount,
    checkNo,
    checkDate,
    refNo,
    remark,
    cashMemoNo,
  ];
}

class ClearPrintData extends InvoicePrintEvent {}
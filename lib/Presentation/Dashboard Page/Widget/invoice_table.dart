import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Common/Models/cart_model.dart';
import '../../../Core/Config/Theme/app_colors.dart';
import '../../../Domain/Entities/customer_entities.dart';
import '../../../Domain/Entities/invoice_entities.dart';
import '../Bloc/cart_bloc.dart';
import '../Bloc/invoice_bloc.dart';
import '../Bloc/invoice_event.dart';
import '../Bloc/invoice_state.dart';
import 'invoice_submit_dialog.dart';

class InvoiceTableWidget extends StatefulWidget {
  final Function(CartItem, double) onDiscountChanged;
  final Map<CartItem, double> itemDiscounts;
  final Customer? selectedCustomer;

  const InvoiceTableWidget({
    super.key,
    required this.onDiscountChanged,
    required this.itemDiscounts,
    required this.selectedCustomer,
  });

  @override
  _InvoiceTableWidgetState createState() => _InvoiceTableWidgetState();
}

class _InvoiceTableWidgetState extends State<InvoiceTableWidget> {
  final Map<String, TextEditingController> _discountControllers = {};
  final TextEditingController _vatController = TextEditingController(text: '0');
  final TextEditingController _invoiceDiscountController = TextEditingController(text: '0');
  final TextEditingController _shippingController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _vatController.addListener(_updateTotal);
    _invoiceDiscountController.addListener(_updateTotal);
    _shippingController.addListener(_updateTotal);
  }

  void _updateTotal() {
    setState(() {});
    print('Customer : ${widget.selectedCustomer}');
  }

  double _calculateTotal(List<CartItem> cartItems) {
    double subtotal = 0;
    for (var item in cartItems) {
      final unitPrice = double.tryParse(item.product.price) ?? 0;
      final itemDiscount = widget.itemDiscounts[item] ?? 0;
      subtotal += (unitPrice * item.quantity) - itemDiscount;
    }
    final vat = double.tryParse(_vatController.text) ?? 0;
    final invoiceDiscount = double.tryParse(_invoiceDiscountController.text) ?? 0;
    final shipping = double.tryParse(_shippingController.text) ?? 0;
    double total = subtotal;
    total += total * (vat / 100);
    total -= total * (invoiceDiscount / 100);
    total += shipping;
    return total;
  }

  String _generateInvoiceNumber() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return 'SI-${DateTime.now().year}-${String.fromCharCodes(Iterable.generate(8, (_) => chars.codeUnitAt(random.nextInt(chars.length))))}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocConsumer<InvoiceBloc, InvoiceState>(
      listener: (context, state) {
        if (state is InvoiceSubmitted) {
          if (state.message == "Sale created successfully.") {
            final invoiceNumber = state.invoice.invoiceNo ?? _generateInvoiceNumber();
            // Access cartItems from CartBloc state
            final cartState = context.read<CartBloc>().state;
            final cartItems = cartState is CartUpdated ? cartState.cartItems : <CartItem>[];
            showDialog(
              context: context,
              builder: (dialogContext) => InvoiceSubmitDialog(
                customer: widget.selectedCustomer,
                totalPrice: _calculateTotal(cartItems),
                invoiceNumber: invoiceNumber,
                cartItems: cartItems,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primary,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else if (state is InvoiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, invoiceState) {
        return BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final cartItems = cartState is CartUpdated ? cartState.cartItems : <CartItem>[];
            final total = _calculateTotal(cartItems);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
                SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    const columnSpacing = 8.0;
                    const numColumns = 6;
                    const totalSpacing = columnSpacing * (numColumns - 1);
                    const actionWidth = 30.0;
                    final remainingWidth = availableWidth - actionWidth - totalSpacing;
                    final otherColumnWidth = remainingWidth / 7;
                    final nameColumnWidth = otherColumnWidth * 2.5;
                    final otherWidths = {
                      'Discount': otherColumnWidth * 0.8,
                      'Unit Price': otherColumnWidth,
                      'Quantity': otherColumnWidth * 0.8,
                      'Total': otherColumnWidth,
                    };
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: availableWidth),
                      child: DataTable(
                        columnSpacing: columnSpacing,
                        border: TableBorder(
                          horizontalInside: BorderSide(color: AppColors.textAsh.withOpacity(0.5), width: 1),
                          verticalInside: BorderSide(color: AppColors.textAsh.withOpacity(0.5), width: 1),
                          top: BorderSide(color: AppColors.textAsh.withOpacity(0.5), width: 1),
                          bottom: BorderSide(color: AppColors.textAsh.withOpacity(0.5), width: 1),
                          left: BorderSide(color: AppColors.textAsh.withOpacity(0.5), width: 1),
                          right: BorderSide(color: AppColors.textAsh.withOpacity(0.5), width: 1),
                        ),
                        columns: [
                          DataColumn(label: Container(alignment: Alignment.centerLeft, child: Text('Action', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600)))),
                          DataColumn(label: Text('Name', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Discount(৳)', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Unit Price', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Quantity', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Total', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600))),
                        ],
                        rows: cartItems.isEmpty
                            ? [
                          DataRow(cells: [
                            DataCell(SizedBox(width: actionWidth)),
                            DataCell(Container(width: nameColumnWidth, child: Text('No items', style: TextStyle(fontFamily: 'Roboto'), overflow: TextOverflow.ellipsis))),
                            DataCell(SizedBox(width: otherWidths['Discount'])),
                            DataCell(SizedBox(width: otherWidths['Unit Price'])),
                            DataCell(SizedBox(width: otherWidths['Quantity'])),
                            DataCell(SizedBox(width: otherWidths['Total'])),
                          ]),
                        ]
                            : cartItems.asMap().entries.map((entry) {
                          final item = entry.value;
                          final product = item.product;
                          final unitPrice = double.tryParse(product.price) ?? 0;
                          if (!_discountControllers.containsKey(product.code)) {
                            _discountControllers[product.code] = TextEditingController(text: '0');
                          }
                          final discountController = _discountControllers[product.code]!;
                          final discount = double.tryParse(discountController.text) ?? 0;
                          final total = (unitPrice * item.quantity) - discount;
                          return DataRow(cells: [
                            DataCell(Container(
                              width: actionWidth,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () {
                                  context.read<CartBloc>().add(RemoveFromCartEvent(product: product));
                                  _discountControllers.remove(product.code)?.dispose();
                                },
                              ),
                            )),
                            DataCell(Container(
                              width: nameColumnWidth,
                              child: Text(product.name, style: TextStyle(fontFamily: 'Roboto'), overflow: TextOverflow.ellipsis, maxLines: 1),
                            )),
                            DataCell(Container(
                              width: otherWidths['Discount'],
                              child: TextField(
                                controller: discountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                                style: TextStyle(fontSize: 12),
                                onChanged: (value) {
                                  widget.onDiscountChanged(item, double.tryParse(value) ?? 0);
                                },
                              ),
                            )),
                            DataCell(Container(
                              width: otherWidths['Unit Price'],
                              child: Text('৳${unitPrice.toStringAsFixed(2)}', style: TextStyle(fontFamily: 'Roboto'), overflow: TextOverflow.ellipsis),
                            )),
                            DataCell(Container(
                              width: otherWidths['Quantity'],
                              child: Text('${item.quantity}', style: TextStyle(fontFamily: 'Roboto'), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                            )),
                            DataCell(Container(
                              width: otherWidths['Total'],
                              child: Text('৳${total.toStringAsFixed(2)}', style: TextStyle(fontFamily: 'Roboto'), overflow: TextOverflow.ellipsis),
                            )),
                          ]);
                        }).toList(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                Text('Invoice Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto')),
                SizedBox(height: 8),
                TextField(
                  controller: _vatController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'VAT (%)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _invoiceDiscountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Invoice Discount (%)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _shippingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Shipping (৳)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(height: 16),
                Text('Total Price: ৳${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Roboto', color: AppColors.primary)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final invoiceNumber = _generateInvoiceNumber();
                        final invoice = Invoice(
                          invoiceNo: invoiceNumber,
                          type: '1',
                          vat: _vatController.text,
                          items: cartItems
                              .map((item) => InvoiceItem(
                            customerId: widget.selectedCustomer?.id.toString(),
                            productId: item.product.id,
                            productName: item.product.name,
                            quantity: item.quantity.toString(),
                            serials: item.product.code.toString(),
                            price: item.product.price,
                            discount: widget.itemDiscounts[item]?.toString() ?? '0',
                            invDiscount: _invoiceDiscountController.text,
                            address: null,
                            description: null,
                            termsAndConditions: null,
                            totalPrice: ((double.tryParse(item.product.price) ?? 0) * item.quantity - (widget.itemDiscounts[item] ?? 0)).toString(),
                            costUnitPrice: item.product.price,
                          ))
                              .toList(),
                        );
                        context.read<InvoiceBloc>().add(SubmitInvoiceEvent(invoice));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        fixedSize: Size(screenWidth * 0.2, screenHeight * 0.08),
                      ),
                      child: Text('Submit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Roboto', color: AppColors.backgroundWhite)),
                    ),
                    ElevatedButton(
                      onPressed: invoiceState is InvoiceSubmitted || invoiceState is CollectionSubmitted
                          ? () {
                        print('Sending to POS printer:');
                        if (invoiceState is InvoiceSubmitted) {
                          print('Invoice: ${invoiceState.invoice.toJson()}');
                        }
                        if (invoiceState is CollectionSubmitted) {
                          print('Collection: ${invoiceState.collection.toJson()}');
                        }
                        context.read<InvoiceBloc>().add(ClearPrintDataEvent());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Printed successfully'), backgroundColor: AppColors.primary, duration: const Duration(seconds: 2)),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        fixedSize: Size(screenWidth * 0.2, screenHeight * 0.08),
                      ),
                      child: Text('Print', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Roboto', color: AppColors.backgroundWhite)),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _discountControllers.values.forEach((controller) => controller.dispose());
    _vatController.dispose();
    _invoiceDiscountController.dispose();
    _shippingController.dispose();
    super.dispose();
  }
}
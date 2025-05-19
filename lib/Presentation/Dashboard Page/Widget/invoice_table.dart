import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';
import '../../../Common/Models/cart_model.dart';
import '../Bloc/cart_bloc.dart';
import 'invoice_submit_dialog.dart';


class InvoiceTableWidget extends StatefulWidget {
  final Function(CartItem, double) onDiscountChanged;
  final Map<CartItem, double> itemDiscounts;
  final dynamic selectedCustomer;

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
    total += total * (vat / 100); // VAT as percentage
    total -= total * (invoiceDiscount / 100); // Invoice Discount as percentage
    total += shipping; // Shipping as flat amount
    return total;
  }

  // Generate a random 16-character alphanumeric string
  String _generateRandomInvoiceNumber() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        16,
            (index) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final cartItems = cartState is CartUpdated ? cartState.cartItems : <CartItem>[];
        final total = _calculateTotal(cartItems);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                // Available width from the right part (flex: 1)
                final availableWidth = constraints.maxWidth;
                print('InvoiceTableWidget available width: $availableWidth');

                // Calculate column widths (6 columns: Action, Name, Discount, Unit Price, Quantity, Total)
                const columnSpacing = 8.0;
                const numColumns = 6;
                const totalSpacing = columnSpacing * (numColumns - 1); // 5 gaps
                const actionWidth = 30.0; // Fixed for delete icon
                final remainingWidth = availableWidth - actionWidth - totalSpacing;
                // Name gets 2.5 portions, others adjusted
                final otherColumnWidth = remainingWidth / 7;
                final nameColumnWidth = otherColumnWidth * 2.5;
                final otherWidths = {
                  'Discount': otherColumnWidth * 0.8,
                  'Unit Price': otherColumnWidth,
                  'Quantity': otherColumnWidth * 0.8, // Narrower for Quantity
                  'Total': otherColumnWidth,
                };

                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: availableWidth),
                  child: DataTable(
                    columnSpacing: columnSpacing,
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: AppColors.textAsh.withOpacity(0.5),
                        width: 1,
                      ),
                      verticalInside: BorderSide(
                        color: AppColors.textAsh.withOpacity(0.5),
                        width: 1,
                      ),
                      top: BorderSide(
                        color: AppColors.textAsh.withOpacity(0.5),
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: AppColors.textAsh.withOpacity(0.5),
                        width: 1,
                      ),
                      left: BorderSide(
                        color: AppColors.textAsh.withOpacity(0.5),
                        width: 1,
                      ),
                      right: BorderSide(
                        color: AppColors.textAsh.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    columns: [
                      DataColumn(
                        label: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Action',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Discount(৳)',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Unit Price',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Quantity',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Total',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    rows: cartItems.isEmpty
                        ? [
                      DataRow(cells: [
                        DataCell(SizedBox(width: actionWidth)),
                        DataCell(
                          Container(
                            width: nameColumnWidth,
                            child: Text(
                              'No items',
                              style: TextStyle(fontFamily: 'Roboto'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
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
                        _discountControllers[product.code] =
                            TextEditingController(text: '0');
                      }
                      final discountController =
                      _discountControllers[product.code]!;
                      final discount =
                          double.tryParse(discountController.text) ?? 0;
                      final total = (unitPrice * item.quantity) - discount;

                      return DataRow(cells: [
                        DataCell(
                          Container(
                            width: actionWidth,
                            child: IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.red, size: 20),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                    RemoveFromCartEvent(product: product));
                                _discountControllers
                                    .remove(product.code)
                                    ?.dispose();
                              },
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: nameColumnWidth,
                            child: Text(
                              product.name,
                              style: TextStyle(fontFamily: 'Roboto'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: otherWidths['Discount'],
                            child: TextField(
                              controller: discountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              style: TextStyle(fontSize: 12),
                              onChanged: (value) {
                                widget.onDiscountChanged(
                                    item, double.tryParse(value) ?? 0);
                              },
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: otherWidths['Unit Price'],
                            child: Text(
                              '৳${unitPrice.toStringAsFixed(2)}',
                              style: TextStyle(fontFamily: 'Roboto'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: otherWidths['Quantity'],
                            child: Text(
                              '${item.quantity}',
                              style: TextStyle(fontFamily: 'Roboto'),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: otherWidths['Total'],
                            child: Text(
                              '৳${total.toStringAsFixed(2)}',
                              style: TextStyle(fontFamily: 'Roboto'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            Text(
              'Invoice Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _vatController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'VAT (%)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _invoiceDiscountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Invoice Discount (%)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _shippingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Shipping (৳)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Total Price: ৳${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final invoiceNumber = _generateRandomInvoiceNumber();
                showDialog(
                  context: context,
                  builder: (dialogContext) => InvoiceSubmitDialog(
                    customer: widget.selectedCustomer,
                    totalPrice: total,
                    invoiceNumber: invoiceNumber, // Placeholder
                    cartItems: cartItems,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
                fixedSize: Size(screenWidth*0.2, screenHeight*0.08)
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: AppColors.backgroundWhite,
                ),
              ),
            ),
          ],
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
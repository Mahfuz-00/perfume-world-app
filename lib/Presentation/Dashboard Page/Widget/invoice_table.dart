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
import '../Bloc/invoice_print_bloc.dart';
import '../Bloc/invoice_print_event.dart';
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
  final FocusNode _invoiceDiscountFocusNode = FocusNode();
  final FocusNode _shippingFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _vatController.addListener(_updateTotal);
    _invoiceDiscountController.addListener(_updateTotal);
    _shippingController.addListener(_updateTotal);

    // Add focus listeners to revert to "0" when focus is lost and field is empty
    _invoiceDiscountFocusNode.addListener(() {
      print('Invoice Discount focus: ${_invoiceDiscountFocusNode.hasFocus}, text: ${_invoiceDiscountController.text}');
      if (!_invoiceDiscountFocusNode.hasFocus && _invoiceDiscountController.text.isEmpty) {
        _invoiceDiscountController.text = '0';
      }
    });
    _shippingFocusNode.addListener(() {
      print('Shipping focus: ${_shippingFocusNode.hasFocus}, text: ${_shippingController.text}');
      if (!_shippingFocusNode.hasFocus && _shippingController.text.isEmpty) {
        _shippingController.text = '0';
      }
    });
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
    return GestureDetector(
      onTap: () {
        // Unfocus TextFields when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: BlocConsumer<InvoiceBloc, InvoiceState>(
          listener: (context, state) {
            if (state is InvoiceSubmitted) {
              if (state.message == "Sale created successfully.") {
                final invoiceNumber = state.invoice.invoiceNo ?? _generateInvoiceNumber();
                final cartState = context.read<CartBloc>().state;
                final cartItems = cartState is CartUpdated ? cartState.cartItems : <CartItem>[];
                context.read<InvoicePrintBloc>().add(InitializePrintData(
                  customer: widget.selectedCustomer,
                  totalPrice: _calculateTotal(cartItems),
                  invoiceNumber: invoiceNumber,
                  cartItems: cartItems,
                  itemDiscounts: widget.itemDiscounts,
                  vat: '0',
                  invoiceDiscount: _invoiceDiscountController.text,
                  shipping: _shippingController.text,
                ));
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
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final tableWidth = constraints.maxWidth;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Invoice Items Table
                        Container(
                          width: tableWidth,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: tableWidth,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundGrey.withOpacity(0.2),
                                  border: Border(
                                    bottom: BorderSide(color: AppColors.primary, width: 1),
                                  ),
                                ),
                                child: Text(
                                  'Invoice Items',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: tableWidth),
                                child: DataTable(
                                  columnSpacing: 8.0,
                                  border: TableBorder(
                                    horizontalInside: BorderSide(color: AppColors.primary, width: 1),
                                    verticalInside: BorderSide(color: AppColors.primary, width: 1),
                                  ),
                                  columns: [
                                    DataColumn(
                                        label: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Action',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black)))),
                                    DataColumn(
                                        label: Text('Name',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))),
                                    DataColumn(
                                        label: Text('Discount(৳)',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))),
                                    DataColumn(
                                        label: Text('Unit Price',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))),
                                    DataColumn(
                                        label: Text('Quantity',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))),
                                    DataColumn(
                                        label: Text('Total',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black))),
                                  ],
                                  rows: cartItems.isEmpty
                                      ? [
                                    DataRow(cells: [
                                      DataCell(SizedBox(width: 20.0)),
                                      DataCell(Container(
                                          width: tableWidth * 0.35,
                                          child: Text('No items',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Colors.black),
                                              overflow: TextOverflow.ellipsis))),
                                      DataCell(SizedBox(width: tableWidth * 0.11)),
                                      DataCell(SizedBox(width: tableWidth * 0.14)),
                                      DataCell(SizedBox(width: tableWidth * 0.09)),
                                      DataCell(SizedBox(width: tableWidth * 0.15)),
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
                                        width: 20.0,
                                        child: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                          onPressed: () {
                                            context.read<CartBloc>().add(RemoveFromCartEvent(product: product));
                                            _discountControllers.remove(product.code)?.dispose();
                                          },
                                        ),
                                      )),
                                      DataCell(Container(
                                        width: tableWidth * 0.35,
                                        child: Text(
                                          product.name,
                                          style: TextStyle(fontFamily: 'Roboto', color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      )),
                                      DataCell(Container(
                                        width: tableWidth * 0.11,
                                        child: TextField(
                                          controller: discountController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(border: OutlineInputBorder(), isDense: true),
                                          style: TextStyle(fontSize: 12, color: Colors.black),
                                          onChanged: (value) {
                                            widget.onDiscountChanged(item, double.tryParse(value) ?? 0);
                                          },
                                        ),
                                      )),
                                      DataCell(Container(
                                        width: tableWidth * 0.14,
                                        child: Text(
                                          '৳${unitPrice}',
                                          style: TextStyle(fontFamily: 'Roboto', color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                      DataCell(Container(
                                        width: tableWidth * 0.09,
                                        child: Text(
                                          '${item.quantity}',
                                          style: TextStyle(fontFamily: 'Roboto', color: Colors.black),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                      DataCell(Container(
                                        width: tableWidth * 0.15,
                                        child: Text(
                                          '৳${total}',
                                          style: TextStyle(fontFamily: 'Roboto', color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Invoice Details Table
                        Container(
                          width: tableWidth,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: tableWidth,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundGrey.withOpacity(0.2),
                                  border: Border(
                                    bottom: BorderSide(color: AppColors.primary, width: 1),
                                  ),
                                ),
                                child: Text(
                                  'Invoice Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: tableWidth * 0.4,
                                          child: Text(
                                            'Invoice Discount (%)',
                                            style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _invoiceDiscountController,
                                            focusNode: _invoiceDiscountFocusNode,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                            ),
                                            style: TextStyle(fontSize: 14, color: Colors.black),
                                            textAlign: TextAlign.right,
                                            onTap: () {
                                              if (_invoiceDiscountController.text == '0') {
                                                _invoiceDiscountController.clear();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(height: 1, color: AppColors.primary),
                                    Row(
                                      children: [
                                        Container(
                                          width: tableWidth * 0.4,
                                          child: Text(
                                            'Shipping (৳)',
                                            style: TextStyle(fontSize: 14, fontFamily: 'Roboto', color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _shippingController,
                                            focusNode: _shippingFocusNode,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                            ),
                                            style: TextStyle(fontSize: 14, color: Colors.black),
                                            textAlign: TextAlign.right,
                                            onTap: () {
                                              if (_shippingController.text == '0') {
                                                _shippingController.clear();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Total Price Table
                        Container(
                          width: tableWidth,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Price:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '৳${total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Submit Button
                        SizedBox(
                          width: tableWidth,
                          child: ElevatedButton(
                            onPressed: () {
                              if (widget.selectedCustomer == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select a customer'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                                return;
                              } else if (cartItems.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Cart is empty'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                                return;
                              } else {
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
                                    totalPrice:
                                    ((double.tryParse(item.product.price) ?? 0) * item.quantity - (widget.itemDiscounts[item] ?? 0)).toString(),
                                    costUnitPrice: item.product.price,
                                  ))
                                      .toList(),
                                );
                                context.read<InvoiceBloc>().add(SubmitInvoiceEvent(invoice));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              minimumSize: Size(tableWidth, screenHeight * 0.08),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Roboto', color: AppColors.backgroundWhite),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );}
            ),
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';

import '../../../Common/Models/cart_model.dart';
import '../Bloc/cart_bloc.dart';

class InvoiceInputsWidget extends StatefulWidget {
  final Map<CartItem, double> itemDiscounts;

  const InvoiceInputsWidget({super.key, required this.itemDiscounts});

  @override
  _InvoiceInputsWidgetState createState() => _InvoiceInputsWidgetState();
}

class _InvoiceInputsWidgetState extends State<InvoiceInputsWidget> {
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
    total += shipping ; // Shipping as percentage (adjust if needed)
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final cartItems = cartState is CartUpdated ? cartState.cartItems : <CartItem>[];
        final total = _calculateTotal(cartItems);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _vatController.dispose();
    _invoiceDiscountController.dispose();
    _shippingController.dispose();
    super.dispose();
  }
}
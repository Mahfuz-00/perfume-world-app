import 'package:flutter/material.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';

class AddCustomerBottomSheet extends StatefulWidget {
  final Function(String, String) onAddCustomer;

  const AddCustomerBottomSheet({super.key, required this.onAddCustomer});

  @override
  _AddCustomerBottomSheetState createState() => _AddCustomerBottomSheetState();
}

class _AddCustomerBottomSheetState extends State<AddCustomerBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New Customer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              errorText: _phoneController.text.length != 11 && _phoneController.text.isNotEmpty ? 'Phone number must be 11 digits' : null,
            ),
            maxLength: 11,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final phone = _phoneController.text.trim();
              if (name.isNotEmpty && phone.isNotEmpty) {
                widget.onAddCustomer(name, phone);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add Customer',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: AppColors.backgroundWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';

import 'add_customer.dart';


class Customer {
  final String name;
  final String phone;

  Customer({required this.name, required this.phone});
}

class CustomerSearchWidget extends StatefulWidget {
  final Function(Customer?) onCustomerSelected;

  const CustomerSearchWidget({super.key, required this.onCustomerSelected});

  @override
  _CustomerSearchWidgetState createState() => _CustomerSearchWidgetState();
}

class _CustomerSearchWidgetState extends State<CustomerSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final List<Customer> _customers = [
    Customer(name: 'John Doe', phone: '1234567890'),
    Customer(name: 'Jane Smith', phone: '0987654321'),
    Customer(name: 'Alice Johnson', phone: '5555555555'),
  ];
  List<Customer> _filteredCustomers = [];
  Customer? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _filteredCustomers = _customers;
    _searchController.addListener(_filterCustomers);
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCustomers = _customers.where((customer) {
        return customer.name.toLowerCase().contains(query) ||
            customer.phone.contains(query);
      }).toList();
    });
  }

  void _addCustomer(String name, String phone) {
    final newCustomer = Customer(name: name, phone: phone);
    setState(() {
      _customers.add(newCustomer);
      _filteredCustomers = _customers;
      _selectedCustomer = newCustomer;
      _searchController.clear();
    });
    widget.onCustomerSelected(newCustomer);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Name or Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.add, color: AppColors.primary),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => AddCustomerBottomSheet(
                    onAddCustomer: _addCustomer,
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        if (_selectedCustomer != null)
          Text(
            'Selected: ${_selectedCustomer!.name} (${_selectedCustomer!.phone})',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              color: AppColors.textAsh,
            ),
          ),
        if (_searchController.text.isNotEmpty && _filteredCustomers.isNotEmpty)
          Container(
            height: 100,
            child: ListView.builder(
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return ListTile(
                  title: Text(
                    '${customer.name} (${customer.phone})',
                    style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedCustomer = customer;
                      _searchController.clear();
                      _filteredCustomers = _customers;
                    });
                    widget.onCustomerSelected(customer);
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
// lib/presentation/dashboard_page/widget/customer_search.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfume_world_app/core/config/theme/app_colors.dart';
import '../../../Domain/Entities/customer_entities.dart';
import '../Bloc/customer_bloc.dart';
import '../Bloc/customer_event.dart';
import '../Bloc/customer_state.dart';
import 'add_customer.dart';

class CustomerSearchWidget extends StatefulWidget {
  final Function(Customer?) onCustomerSelected;

  const CustomerSearchWidget({super.key, required this.onCustomerSelected});

  @override
  _CustomerSearchWidgetState createState() => _CustomerSearchWidgetState();
}

class _CustomerSearchWidgetState extends State<CustomerSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Customer> _filteredCustomers = [];
  Customer? _selectedCustomer;
  String? _lastAddedName; // Store name of last added customer
  String? _lastAddedPhone; // Store phone of last added customer

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(FetchCustomers());
    _searchController.addListener(_filterCustomers);
  }

  void _filterCustomers() {
    final query = _searchController.text.trim().toLowerCase();
    final state = context.read<CustomerBloc>().state;
    setState(() {
      if (state is CustomerLoaded) {
        _filteredCustomers = query.isEmpty
            ? state.customers
            : state.customers.where((customer) {
          return customer.name.toLowerCase().contains(query) ||
              customer.phone.contains(query);
        }).toList();
      } else {
        _filteredCustomers = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBloc, CustomerState>(
      listener: (context, state) {
        if (state is CustomerAdded) {
          // Handle new customer added
          if (_lastAddedName != null && _lastAddedPhone != null) {
            final newCustomer = Customer(
              id: 0, // Placeholder ID
              name: _lastAddedName!,
              phone: _lastAddedPhone!,
              previousDue: 0,
            );
            setState(() {
              _selectedCustomer = newCustomer;
              _searchController.clear();
              // Keep _filteredCustomers as is (no re-fetch)
              _lastAddedName = null; // Clear stored values
              _lastAddedPhone = null;
            });
            widget.onCustomerSelected(newCustomer);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is CustomerError) {
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
        if (state is CustomerLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Only update _filteredCustomers when query is empty and state is loaded
        if (state is CustomerLoaded && _searchController.text.isEmpty) {
          _filteredCustomers = state.customers;
        }

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
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add, color: AppColors.primary),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => AddCustomerBottomSheet(
                        onAddCustomer: (name, phone) {
                          setState(() {
                            _lastAddedName = name; // Store name
                            _lastAddedPhone = phone; // Store phone
                          });
                          context.read<CustomerBloc>().add(
                            AddCustomerEvent(name: name, phone: phone),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
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
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: _filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = _filteredCustomers[index];
                    return ListTile(
                      title: Text(
                        '${customer.name} (${customer.phone})',
                        style: const TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCustomer = customer;
                          _searchController.clear();
                          _filteredCustomers = (state is CustomerLoaded) ? state.customers : _filteredCustomers;
                        });
                        widget.onCustomerSelected(customer);
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCustomers);
    _searchController.dispose();
    super.dispose();
  }
}
// lib/presentation/widgets/customer_search.dart
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

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(FetchCustomers());
    _searchController.addListener(_filterCustomers);
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    final state = context.read<CustomerBloc>().state;
    if (state is CustomerLoaded) {
      setState(() {
        _filteredCustomers = state.customers.where((customer) {
          return customer.name.toLowerCase().contains(query) ||
              customer.phone.contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBloc, CustomerState>(
      listener: (context, state) {
        if (state is CustomerAdded) {
          setState(() {
            _selectedCustomer = state.customer;
            _searchController.clear();
          });
          widget.onCustomerSelected(state.customer);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Customer added successfully'),
              backgroundColor: AppColors.primary,
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is CustomerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CustomerLoading) {
          return Center(child: CircularProgressIndicator());
        }

        _filteredCustomers = (state is CustomerLoaded) ? state.customers : _filteredCustomers;

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
                        onAddCustomer: (name, phone) {
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
    _searchController.dispose();
    super.dispose();
  }
}
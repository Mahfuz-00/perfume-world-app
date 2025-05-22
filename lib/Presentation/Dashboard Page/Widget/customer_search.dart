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
  int _retryCount = 0; // Limit retries
  bool cleared = false;

  void clearCustomerTemporarily() {
    setState(() {
      _selectedCustomer = null;
      cleared = true;
    });

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        cleared = false;
      });
    });
  }

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
        _filteredCustomers = state.customers
            .map((c) => Customer(
          id: c.id,
          name: c.name,
          phone: c.phone,
          previousDue: c.previousDue ?? 0,
        ))
            .where((customer) {
          return customer.name.toLowerCase().contains(query) ||
              customer.phone.contains(query);
        })
            .toList();
      } else {
        _filteredCustomers = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerBloc, CustomerState>(
      listener: (context, state) {
        print('CustomerBloc State: $state');
        if (state is CustomerAdded) {
          // Clear search, show SnackBar, wait for CustomerLoaded
          setState(() {
            _searchController.clear();
            _retryCount = 0; // Reset retries
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is CustomerLoaded && _lastAddedPhone != null) {
          // Find customer by phone after fetch
          print('Looking for customer with phone: $_lastAddedPhone');
          print('Available customers: ${state.customers.map((c) => c.phone).toList()}');
          dynamic fetchedCustomer;
          for (var customer in state.customers) {
            if (customer.phone == _lastAddedPhone) {
              fetchedCustomer = customer;
              break;
            }
          }
          if (fetchedCustomer != null) {
            final selectedCustomer = Customer(
              id: fetchedCustomer.id,
              name: fetchedCustomer.name,
              phone: fetchedCustomer.phone,
              previousDue: fetchedCustomer.previousDue ?? 0,
            );
            print('Selected customer: ${selectedCustomer.name}, ID: ${selectedCustomer.id}');
            setState(() {
              _selectedCustomer = selectedCustomer;
              _lastAddedName = null;
              _lastAddedPhone = null;
              _retryCount = 0;
            });
            widget.onCustomerSelected(selectedCustomer);
          } else {
            print('Customer with phone $_lastAddedPhone not found');
            if (_retryCount < 2) {
              _retryCount++;
              print('Retrying fetch ($_retryCount/2) for phone: $_lastAddedPhone');
              Future.delayed(Duration(seconds: 2), () {
                if (_lastAddedPhone != null) {
                  context.read<CustomerBloc>().add(FetchCustomers());
                }
              });
            }
          }
        } else if (state is CustomerError) {
          print('CustomerError: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is CustomerCleared) {
          clearCustomerTemporarily();
          setState(() {
            _filteredCustomers = [];
            _searchController.clear();
            _selectedCustomer = null;
          });
        }
      },
      builder: (context, state) {
        if (state is CustomerLoaded && _searchController.text.isEmpty) {
          _filteredCustomers = state.customers
              .map((c) => Customer(
            id: c.id,
            name: c.name,
            phone: c.phone,
            previousDue: c.previousDue ?? 0,
          ))
              .toList();
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
                      suffixIcon: state is CustomerLoading
                          ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                          : Icon(Icons.search, color: AppColors.textAsh),
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
                            _lastAddedName = name;
                            _lastAddedPhone = phone;
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
            if (_selectedCustomer != null && !cleared) ...[
              Text(
                'Selected: ${_selectedCustomer!.name} (${_selectedCustomer!.phone})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: AppColors.textAsh,
                ),
              ),
            ],
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
                          _searchController.text = '';
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
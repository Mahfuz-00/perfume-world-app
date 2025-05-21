import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Domain/Entities/customer_entities.dart';
import '../../../Domain/Usecases/add_customer_usecase.dart';
import '../../../Domain/Usecases/get_customer_usecase.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomers getCustomers;
  final AddCustomer addCustomer;

  CustomerBloc(this.getCustomers, this.addCustomer) : super(CustomerInitial()) {
    on<FetchCustomers>(_onFetchCustomers);
    on<AddCustomerEvent>(_onAddCustomer);
  }

  Future<void> _onFetchCustomers(FetchCustomers event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final customers = await getCustomers();
      emit(CustomerLoaded(customers as List<Customer>));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onAddCustomer(AddCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final customer = await addCustomer(event.name, event.phone);
      emit(CustomerAdded(customer));
      final customers = await getCustomers();
      emit(CustomerLoaded(customers as List<Customer>));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }
}
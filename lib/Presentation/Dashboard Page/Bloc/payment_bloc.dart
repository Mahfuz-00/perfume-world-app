import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Domain/Usecases/payment_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';


class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final GetPaymentMethods getPaymentMethods;

  PaymentMethodBloc({required this.getPaymentMethods}) : super(PaymentMethodInitial()) {
    on<FetchPaymentMethods>((event, emit) async {
      emit(PaymentMethodLoading());
      try {
        final paymentMethods = await getPaymentMethods();
        emit(PaymentMethodLoaded(paymentMethods));
      } catch (e) {
        emit(PaymentMethodError(e.toString()));
      }
    });
    on<ClearPaymentMethodEvent>((event, emit) {
      print('Clearing PaymentMethodBloc state');
      emit(PaymentMethodInitial());
    });
  }
}
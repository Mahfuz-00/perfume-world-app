import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Domain/Entities/voucher_entites.dart';
import '../../../Domain/Usecases/voucher_usecase.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final GetVouchers getVouchers;

  VoucherBloc({required this.getVouchers}) : super(VoucherInitial()) {
    on<FetchVouchersEvent>((event, emit) async {
      emit(VoucherLoading());
      try {
        final vouchers = await getVouchers.call();
        emit(VoucherLoaded(vouchers: vouchers));
      } catch (e) {
        emit(VoucherError(message: e.toString()));
      }
    });
  }
}

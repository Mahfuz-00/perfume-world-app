import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../Domain/Entities/voucher_form_entities.dart';
import '../../../Domain/Usecases/voucher_form_usecase.dart';

part 'voucher_form_event.dart';
part 'voucher_form_state.dart';

class VoucherFormBloc extends Bloc<VoucherFormEvent, VoucherFormState> {
  final SubmitVoucherFormUseCase submitVoucherFormUseCase;

  VoucherFormBloc({required this.submitVoucherFormUseCase}) : super(VoucherFormInitial()) {
    on<SubmitVoucherFormEvent>(_onSubmitVoucherFormEvent);
  }

  Future<void> _onSubmitVoucherFormEvent(
      SubmitVoucherFormEvent event,
      Emitter<VoucherFormState> emit,
      ) async {
    emit(VoucherFormLoading());
    try {
      await submitVoucherFormUseCase(event.voucher);
      emit(VoucherFormSuccess());
    } catch (e) {
      emit(VoucherFormFailure(e.toString()));
    }
  }
}


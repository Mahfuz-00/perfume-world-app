import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Domain/Usecases/signout_usecase.dart';

part 'signout_event.dart';
part 'signout_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUseCase signoutUseCase;

  SignOutBloc({required this.signoutUseCase}) : super(SignOutInitial()) {
    // Register event handler for SignoutEvent
    on<SignoutEvent>((event, emit) async {
      emit(SignOutLoading());
      try {
        print('Signing...Out');
        await signoutUseCase.call();
        print('Signed Out');
        emit(SignedOut());
      } catch (e) {
        emit(SignOutError(e.toString()));
      }
    });
  }
}

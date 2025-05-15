import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../Domain/Usecases/sign_in_usercases.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SigninUseCase signinUseCase;

  SignInBloc(this.signinUseCase) : super(SignInInitial()) {
    on<PerformSignInEvent>((event, emit) async {
      emit(SignInLoading());

      try {
        // Perform login with the signinUseCase
        final token = await signinUseCase.login(
            event.username,
            event.password,
            rememberMe: event.rememberMe);

        // Emit the token on successful login
        emit(SignInSuccess(token)); // Passing the token here
      } catch (e) {
        emit(SignInFailure("Login failed: $e"));
      }
    });
  }
}

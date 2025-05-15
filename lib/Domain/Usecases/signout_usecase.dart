import '../Repositories/signout_repositories.dart';

class SignOutUseCase {
  final SignOutRepository signOutRepository;

  SignOutUseCase({required this.signOutRepository});

  Future<void> call() async {
    await signOutRepository.logout();
  }
}

import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<void> call(
      String email,
      String password,
      ) async {
    await repository.signup(
      email,
      password,
    );
  }
}
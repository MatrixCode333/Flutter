import '../../damain/repositories/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> login(
      String email,
      String password,
      ) async {
    await remoteDataSource.login(email, password);
  }

  @override
  Future<void> signup(
      String email,
      String password,
      ) async {
    await remoteDataSource.signup(
      email,
      password,
    );
  }
}
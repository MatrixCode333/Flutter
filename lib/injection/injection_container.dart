import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/auth/damain/repositories/auth_repository.dart';
import '../features/auth/damain/usecases/login_usecase.dart';
import '../features/auth/data/datasource/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/bloc/login_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // Datasource
  sl.registerLazySingleton(
        () => AuthRemoteDataSource(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl()),
  );

  // Usecase
  sl.registerLazySingleton(
        () => LoginUseCase(sl()),
  );

  // Bloc
  sl.registerFactory(
        () => LoginBloc(sl(),sl()),
  );
}
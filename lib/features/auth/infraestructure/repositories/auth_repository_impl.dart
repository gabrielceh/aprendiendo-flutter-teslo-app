import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infraestructure/infraestructure.dart';

class AuthRepositoryImpl extends AuthRepository {

  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(
    [AuthDataSource? authDataSource] // optional parameter
  ) : _authDataSource = authDataSource ?? AuthDataSourceImpl()
  ;


  @override
  Future<User> checkoutStatus(String token) {
    return _authDataSource.checkoutStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return _authDataSource.login(email, password);
  }

  @override
  Future<User> register({required String email, required String password, required String fullName}) {
   return _authDataSource.register(
    email: email,
    password: password,
    fullName: fullName,
   );
  }
}
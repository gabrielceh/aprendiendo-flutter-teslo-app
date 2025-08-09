import 'package:teslo_app/features/auth/domain/domain.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password, String fullName);
  Future<User> checkoutStatus(String token);
}
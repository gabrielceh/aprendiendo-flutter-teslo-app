import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infraestructure/infraestructure.dart';
import 'package:teslo_app/features/auth/infraestructure/models/user_response.dart';

class AuthDataSourceImpl extends AuthDataSource {

  final dio  = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  User _fromJsonToUser(Map<String, dynamic> json) {
    final userResponse = UserResponse.fromJson(json);

    return UserMapper.userJsonToEntity(userResponse);
  }

  @override
  Future<User> checkoutStatus(String token) {
    // TODO: implement checkoutStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async{
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = _fromJsonToUser(response.data);
      return user;
    }
    on DioException catch (e) {
      if(e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Wrong credentials');
      }
      if(e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Tiempo de conexión agotado, revisa tu conexión');
      }
      throw Exception();
    }
    catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String name, String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }

}
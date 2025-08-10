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
  Future<User> checkoutStatus(String token) async{
    try {
      final response = await dio.get('/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final user = _fromJsonToUser(response.data);
      print(user);
      return user;
    } on DioException catch (e) {
      if(e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token no válido');
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
        throw CustomError(e.response?.data['message'] ?? 'Credenciales incorrectas');
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
  Future<User> register({required String email, required String password, required String fullName}) async {
    try{
      final response = await dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'fullName': fullName,
      });
      final user = _fromJsonToUser(response.data);
      return user;
    }on DioException catch (e) {
      if(e.response?.statusCode == 400) {
        if(e.response?.data['message'] is List){
          throw CustomError(e.response?.data['message'][0] ?? 'Verifica que los datos sean correctos');
        }
        throw CustomError(e.response?.data['message'] ?? 'Verifica que los datos sean correctos');
      }
      if(e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Tiempo de conexión agotado, revisa tu conexión');
      }
      throw Exception();
    }catch(e){
      throw Exception();
    }
  }

}
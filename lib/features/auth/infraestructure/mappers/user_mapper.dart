import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infraestructure/models/user_response.dart';

class UserMapper {

  static User userJsonToEntity(UserResponse json) {
    return User(
      id: json.id,
      email: json.email,
      fullName: json.fullName,
      token: json.token ?? '',
      roles: List<String>.from(json.roles.map((role)=> role)),
    );
  }
}
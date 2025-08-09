import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infraestructure/infraestructure.dart';

// el authProvider es el que se va a conectar con el repositorio de autenticación para la implementación de la lógica de negocio.

// ! 3 - crear el StateNotifierProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

class AuthDatasourceImpl {
}


enum AuthStatus {checking, authenticated, notAuthenticated}

// ! 1 - crear el estado
class AuthState{
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus  = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


// ! 2 - crear el StateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({
   required this.authRepository
  }) : super(AuthState());

  void _setLoggedUser(User user) {
    // TODO: necesitaremos guardar el token
    state = state.copyWith(
      user: user, authStatus: 
      AuthStatus.authenticated, 
      errorMessage: '',
    );
  }


  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula un retardo de 1 segundo, no es necesario en producción
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    }on CustomError catch (e) {
      logout(errorMessage: e.message);
    } catch (e) {
      logout(errorMessage: 'Error no controlado');
    }

    
  }

  Future<void> registerUser({required String email, required String password, required String fullName}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula un retardo de 1 segundo, no es necesario en producción
    try {
      final user = await authRepository.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      _setLoggedUser(user);
    }on CustomError catch (e) {
      logout(errorMessage: e.message);
    } catch (e) {
      logout(errorMessage: 'Error no controlado del registro');
    }
    
  }

  void checkAuthStatus() async {
    
  }

  Future<void> logout({String? errorMessage}) async {
    // TODO: necesitaremos borrar el token
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage ?? '',
    );
  }
  
}


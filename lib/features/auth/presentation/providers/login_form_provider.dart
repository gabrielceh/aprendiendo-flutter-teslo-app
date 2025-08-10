import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_app/features/shared/shared.dart';

import 'auth_provider.dart';

// ! 3 - StateNotifierProvider
// autoDispose para que se elimine cuando no se use
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref){
  // Aquí podrías inyectar dependencias si es necesario
  // Por ejemplo, si necesitas un repositorio o servicio para manejar el login
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;


  return LoginFormNotifier(loginUserCallback: loginUserCallback);
  },
); 


// ! 1 - crear el state del provider
class LoginFormState{
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  const LoginFormState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
  });

  LoginFormState copyWith({
    Email? email,
    Password? password,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
  }) {
    return LoginFormState(
      email: email ?? this.email, 
      password: password ?? this.password, 
      isPosting: isPosting ?? this.isPosting, 
      isFormPosted: isFormPosted ?? this.isFormPosted, 
      isValid: isValid ?? this.isValid, 
    );
  }

  @override
  String toString() {
    return '''
    LoginFormState {
      email: $email,
      password: $password,
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
    }
    ''';
  }
}

// ! 2 - Implementar el notifier

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  Future<void> Function(String, String) loginUserCallback;

  LoginFormNotifier({
    required this.loginUserCallback,
  }): super(LoginFormState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  onFormSubmit() async{
    _touchEveryField();
    if(!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await loginUserCallback(state.email.value, state.password.value);
    
    state = state.copyWith(isPosting: false);
  }

  // verificar si se tocaron todos los campor para el manejo de errores
  _touchEveryField(){
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }
}


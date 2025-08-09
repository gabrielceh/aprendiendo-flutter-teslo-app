import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_app/features/auth/presentation/providers/providers.dart';

import '../../../shared/infraestructure/inputs/inputs.dart';

// ! 3 - StateNotifierProvider
final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref){
  // Aquí podrías inyectar dependencias si es necesario
  // Por ejemplo, si necesitas un repositorio o servicio para manejar el login
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
  },
);


// 1 - state
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final TextInput fullName;
  final ConfirmPassword confirmPassword;

  const RegisterFormState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.fullName = const TextInput.pure(), 
    this.confirmPassword = const ConfirmPassword.pure(), 
  });

  RegisterFormState copyWith({
    Email? email,
    Password? password,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    TextInput? fullName,
    ConfirmPassword? confirmPassword,
  }) {
    return RegisterFormState(
      email: email ?? this.email, 
      password: password ?? this.password, 
      isPosting: isPosting ?? this.isPosting, 
      isFormPosted: isFormPosted ?? this.isFormPosted, 
      isValid: isValid ?? this.isValid, 
      fullName: fullName ?? this.fullName, 
      confirmPassword: confirmPassword ?? this.confirmPassword, 
    );
  }

  @override
  String toString() {
    return '''
    RegisterFormState {
      email: $email,
      password: $password,
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      fullName: $fullName,
      confirmPassword: $confirmPassword,
    }
    ''';
  }
}

// ! NOTIFIER

class RegisterFormNotifier extends StateNotifier<RegisterFormState>{
  Future<void> Function({required String email, required String fullName, required String password})  registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback
  }): super(RegisterFormState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password, state.fullName, state.confirmPassword]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email, state.fullName, state.confirmPassword]),
    );
  }

  onFullNameChanged(String value) {
    final newFullName = TextInput.dirty(value);
    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([newFullName, state.email, state.password, state.confirmPassword]),
    );
  }

  onConfirmPasswordChanged(String value) {
    final newConfirmPassword = ConfirmPassword.dirty(
      password: state.password.value,
      value: value
    );
    state = state.copyWith(
      confirmPassword: newConfirmPassword,
      isValid: Formz.validate([newConfirmPassword, state.email, state.password, state.fullName]),
    );
  }

  onSubmit() async {
    // verificar si el formulario es válido
    if(!state.isValid) {
      _touchEveryField();
      return;
    }
    registerUserCallback(
      email: state.email.value,
      password: state.password.value,
      fullName: state.fullName.value,
    );

  }

  // verificar si se tocaron todos los campor para el manejo de errores
  _touchEveryField(){
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = TextInput.dirty(state.fullName.value);
    final confirmPassword = ConfirmPassword.dirty(
      password: state.password.value,
      value: state.confirmPassword.value
    );
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      fullName: fullName,
      confirmPassword: confirmPassword,
      isValid: Formz.validate([email, password, fullName, confirmPassword]),
    );
  }

  
}
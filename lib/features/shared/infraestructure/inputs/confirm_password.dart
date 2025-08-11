import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError {isEmpty, mismatch }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordValidationError> {
  final String confirmPassword;

  const ConfirmPassword.pure({this.confirmPassword = ''}) : super.pure('');
  const ConfirmPassword.dirty({required this.confirmPassword, String password = ''}) : super.dirty(password);

  String? get errorMessage{
    if(isValid || isPure) return null;

    if(displayError == ConfirmPasswordValidationError.isEmpty) return 'El campo es requerido';
    if(displayError == ConfirmPasswordValidationError.mismatch) return 'Las contraseñas no coinciden';

    return null;
  }

  @override
  ConfirmPasswordValidationError? validator(String password) {
    if(confirmPassword != password) return ConfirmPasswordValidationError.mismatch;
    if(password.isEmpty) return ConfirmPasswordValidationError.isEmpty;
    return null;
  }
}

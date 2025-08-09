import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { mismatch }

class ConfirmPassword extends FormzInput<String, ConfirmPasswordValidationError> {
  final String password;

  const ConfirmPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmPassword.dirty({required this.password, String value = ''}) : super.dirty(value);

  String? get errorMessage{
    if(isValid || isPure) return null;

    if(displayError == ConfirmPasswordValidationError.mismatch) return 'Las contraseñas no coinciden';

    return null;
  }

  @override
  ConfirmPasswordValidationError? validator(String value) {
    return password == value ? null : ConfirmPasswordValidationError.mismatch;
  }
}

import 'package:formz/formz.dart';

enum TextInputError { empty }

class TextInput extends FormzInput<String, TextInputError> {
  const TextInput.pure() : super.pure('');
  const TextInput.dirty( String value ) : super.dirty(value);

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == TextInputError.empty ) return 'El campo es requerido';

    return null;
  }

  @override
  TextInputError? validator(String value) {
    if ( value.isEmpty || value.trim().isEmpty ) return TextInputError.empty;
    return null;
  }
}
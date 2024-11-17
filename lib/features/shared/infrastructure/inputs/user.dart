import 'package:formz/formz.dart';

// Define input validation errors
enum UsernameError { empty, format }

// Extend FormzInput and provide the input type and error type.
class Username extends FormzInput<String, UsernameError> {
  // Call super.pure to represent an unmodified form input.
  const Username.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Username.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UsernameError.empty) {
      return 'El campo es requerido';
    }
    if (displayError == UsernameError.format) {
      return 'El nombre de usuario no puede contener caracteres especiales';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  UsernameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UsernameError.empty;

    // Example format validation: no special characters
    final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    if (!usernameRegExp.hasMatch(value)) return UsernameError.format;

    return null;
  }
}

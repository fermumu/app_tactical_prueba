class ValidationService {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return null; // No muestra mensaje de error si el campo está vacío
    }
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (emailRegExp.hasMatch(value)) {
      return null; // El correo es válido, no hay error
    }
    return 'Por favor, ingrese un correo válido.';
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return null; // No muestra mensaje de error si el campo está vacío
    }
    if (value.length >= 6) {
      return null; // La contraseña cumple con los requisitos, no hay error
    }
    return 'La contraseña debe tener al menos 6 caracteres.';
  }

  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return null; // No muestra mensaje de error si el campo está vacío
    }
    if (confirmPassword == password) {
      return null; // Las contraseñas coinciden, no hay error
    }
    return 'Las contraseñas no coinciden.';
  }
}

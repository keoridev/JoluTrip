class Validators {
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    return password.length >= 6;
  }

  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    return name.length >= 2 && name.length <= 50;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) return 'Email обязателен';
    if (!isValidEmail(email)) return 'Введите корректный email';
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Пароль обязателен';
    if (!isValidPassword(password)) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) return 'Имя обязательно';
    if (!isValidName(name)) {
      return 'Имя должно содержать от 2 до 50 символов';
    }
    return null;
  }
}

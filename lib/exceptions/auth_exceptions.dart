/// `UserNotFound`: Не найден пользователь
class UserNotFound implements Exception {
  @override
  String toString() => 'UserNotFound';
}

/// `LoginAlreadyRegistered`: Логин уже используется
class LoginAlreadyRegistered implements Exception {
  @override
  String toString() => 'LoginAlreadyRegistered';
}

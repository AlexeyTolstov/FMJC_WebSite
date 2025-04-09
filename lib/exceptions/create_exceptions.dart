/// `AddSuggestionException`: ошибка при добавлении предложения
class AddSuggestionException implements Exception {
  @override
  String toString() => 'AddSuggestionException';
}

/// `TokenDoesNotExist`: Токена не существует
class TokenDoesNotExist implements Exception {
  @override
  String toString() => 'TokenDoesNotExist';
}

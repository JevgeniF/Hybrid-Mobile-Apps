class AuthenticationException implements Exception {
  // ignore: prefer_typing_uninitialized_variables
  final message;

  AuthenticationException(this.message);

  @override
  String toString() {
    return message;
  }
}

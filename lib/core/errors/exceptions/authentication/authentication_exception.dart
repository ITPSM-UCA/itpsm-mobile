class AuthenticationException implements Exception {
  final String title;
  final String message;

  const AuthenticationException({required this.title, required this.message});
}
class ServerException implements Exception {
  final String title;
  final String message;

  const ServerException({required this.title, required this.message});
}
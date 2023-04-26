class ServerException implements Exception {
  final String title;
  final String message;

  ServerException({required this.title, required this.message});
}
class CacheException implements Exception {
  final String title;
  final String message;

  CacheException({required this.title, required this.message});
}
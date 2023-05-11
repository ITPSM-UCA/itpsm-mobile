class CacheException implements Exception {
  final String title;
  final String message;

  const CacheException({required this.title, required this.message});
}
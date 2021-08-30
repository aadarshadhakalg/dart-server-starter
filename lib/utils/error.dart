class InvalidDataError implements Exception {
  final String message;
  InvalidDataError(this.message);
}

class DatabaseInsertionError implements Exception {
  final String message;
  DatabaseInsertionError(this.message);
}

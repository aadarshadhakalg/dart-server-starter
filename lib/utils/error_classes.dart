class InvalidDataError implements Exception {
  final String message;
  InvalidDataError(this.message);
}

class DatabaseInsertionError implements Exception {
  final String message;
  DatabaseInsertionError(this.message);
}

class NoRecordError implements Exception {
  final String message;
  NoRecordError(this.message);
}

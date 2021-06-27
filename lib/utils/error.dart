abstract class AppError{
  String? message;
  AppError([this.message]);
}


class InvalidDataError extends AppError{
  InvalidDataError([String? message]) : super(message);
}

class DatabaseInsertionError extends AppError{
  DatabaseInsertionError([String? message]) : super(message);
}
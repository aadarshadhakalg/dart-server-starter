import 'dart:async';
import 'package:shelf/shelf.dart';

class NotFoundHandler {
  /// Custom 404 Not Found Handler
  ///
  /// Edit the call method to handle 404 exception.
  /// By default, it returns '404 Not Found' message
  /// as the response.
  ///
  FutureOr<Response> call(request) {
    return Response.notFound('404 Not Found');
  }
}

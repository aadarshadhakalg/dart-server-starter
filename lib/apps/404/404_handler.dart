import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';

class NotFoundHandler {
  FutureOr<Response> call(request) {
    var notFoundTemplate = File('public/404.html').readAsStringSync();
    return Response.notFound(notFoundTemplate, headers: {
      'content-type': 'text/html',
    });
  }
}

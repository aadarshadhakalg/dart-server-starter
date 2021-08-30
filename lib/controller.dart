import 'dart:async';

import 'package:dartserverstarter/utils/controller.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'apps/blog/blog.controller.dart';
import 'apps/users/user.controller.dart';

class MainAppController extends WebController {
  @override
  Router registerRoute() {
    router.mount('/users/', UsersController().registerRoute());
    router.mount('/blogs/', BlogController().registerRoute());

    /// For Static Files
    /// Create a public folder in the project root directory and the assets
    /// folder inside it containing assets files.
    /// The assets then can be accessible from path http:{address}/assets/{path}
    ///
    /// 1. Run 'dart pub add shelf_static'
    /// 2. import 'package:shelf_static/shelf_static.dart';
    /// 3. Uncomment the line below.
    ///
    /// router.get('/assets/<file|.*>', createStaticHandler('public'));
    return super.registerRoute();
  }

  FutureOr<Response> Function(Request) coreHandler() {
    /// Method to register middlewares and handlers.
    ///
    /// [Pipeline] is a
    /// helper that makes it easy to compose a set of Middleware and a Handler.
    var pipeline = Pipeline()
        .addMiddleware(
          logRequests(),
        )
        .addMiddleware(
          corsHeaders(
            headers: {
              ACCESS_CONTROL_ALLOW_ORIGIN: '*',
            },
          ),
        );

    return pipeline.addHandler(registerRoute());
  }
}

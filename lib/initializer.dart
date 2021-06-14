import 'dart:async';
import 'dart:io';
import 'package:dartserverstarter/apps/home/home.dart';
import 'package:dartserverstarter/apps/users/users.dart';
import 'package:dartserverstarter/core/database.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as server_io;
import 'package:shelf_static/shelf_static.dart';
import 'apps/404/404_handler.dart';

class Initializer {
  // Initialized Router
  final _shelfRouter = Router(notFoundHandler: NotFoundHandler());

  // Register App Routes
  void registerRoute() {
    _shelfRouter.get('/', HomeController().registerRoute());
    _shelfRouter.mount('/users/', UsersController().registerRoute());

    // For Static Files
    _shelfRouter.get('/assets/<file|.*>', createStaticHandler('public'));
  }

  // Add Register Serverwide Middlewares
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

  // Establidh Mongodb connection
  var db = DatabaseSetupConnection.instance
    ..uriString('mongodb://localhost:27017/dart-server-starter')
    ..connect().then((value) {
      print('Database Connection Established Successfully');
    }, onError: (e) {
      print(e.toString());
      exit(1);
    });

  // Start Server
  FutureOr<HttpServer> call() async {
    registerRoute();
    var handler = pipeline.addHandler(_shelfRouter);
    return await server_io.serve(handler, 'localhost', 8080);
  }
}

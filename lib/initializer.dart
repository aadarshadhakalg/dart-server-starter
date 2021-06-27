import 'dart:async';
import 'dart:io';
import 'package:dartserverstarter/apps/users/user.controller.dart';
import 'package:dartserverstarter/utils/database.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as server_io;
import 'utils/404_handler.dart';

export 'dart:io';
export 'package:shelf_hotreload/shelf_hotreload.dart';

class Initializer {
  // Initialized Router
  final _shelfRouter = Router(notFoundHandler: NotFoundHandler());

  // Register App Routes
  void registerRoute() {
    _shelfRouter.mount('/users/', UsersController().registerRoute());

    // For Static Files
    // Create a public folder in the project root directory and the assets
    // folder inside it containing assets files.
    // The assets then can be accessible from path http:{address}/assets/{path}
    //
    // 1. Run 'dart pub add shelf_static'
    // 2. import 'package:shelf_static/shelf_static.dart';
    // 3. Uncomment the line below.
    //
    // _shelfRouter.get('/assets/<file|.*>', createStaticHandler('public'));
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

  Future<void> connectDatabase() async {
    // Establidh Mongodb connection
    try {
      var db = DatabaseSetupConnection.instance
        ..uriString('mongodb://localhost:27017/starter');
      await db.connect();
      stdout.write('Database Connection Established Successfully');
    } catch (e) {
      stderr.write(e);
      exit(1);
    }
  }

  // Start Server
  FutureOr<HttpServer> call() async {
    registerRoute();
    await connectDatabase();
    var handler = pipeline.addHandler(_shelfRouter);
    return await server_io.serve(handler, 'localhost', 8080);
  }
}

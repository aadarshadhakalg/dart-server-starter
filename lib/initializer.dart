import 'dart:async';
import 'dart:io';
import 'package:dartserverstarter/utils/database.dart';
import 'package:postgresql2/pool.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as server_io;
import 'apps/users/user.controller.dart';
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
    // Establidh Postgresql connection
    // Keep ths in .env later
    String dbUrl = 'postgres://aadarsha:ad@localhost:5432/aadarsha';
    try {
      Pool pool = Pool(dbUrl, minConnections: 2, maxConnections: 5);
      await pool.start();
      database = await pool.connect();
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

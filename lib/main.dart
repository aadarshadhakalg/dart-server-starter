import 'dart:async';
import 'dart:io';
import 'package:dartserverstarter/config.dart';
import 'package:dartserverstarter/controller.dart';
import 'package:dartserverstarter/utils/database_service.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf/shelf_io.dart' as server_io;

void main(List<String> args) async {
  late HttpServer server;

  /// Add's support for hot reload
  /// Comes from package shelf_hotreload
  if (Config.ENABLE_HOT_RELOAD) {
    withHotreload(() async {
      server = await Initializer().call();
      print(
          'Server started at: http://${Config.SERVER_HOST}:${Config.SERVER_PORT}');
      return server;
    });
  } else {
    server = await Initializer().call();
    print(
        'Server started at: http://${Config.SERVER_HOST}:${Config.SERVER_PORT}');
  }

  server.autoCompress = Config.PRODUCTION;
}

class Initializer {
  Future<void> startDatabaseService() async {
    await DatabaseService().startPostGres(
      dbusername: Config.DBUSERNAME,
      dbpassword: Config.DBPASSWORD,
      dbhost: Config.DBHOST,
      dbport: Config.DBPORT,
      dbname: Config.DBNAME,
      minPool: Config.MINPOOLCONNECTION,
      maxPool: Config.MAXPOOLCONNECTION,
    );

    await DatabaseService().startRedis(Config.RedisHost, Config.RedisPort);
  }

  // Start Server
  FutureOr<HttpServer> call() async {
    await startDatabaseService();
    var handler = MainAppController().coreHandler();
    return await server_io.serve(
      handler,
      Config.SERVER_HOST,
      int.parse(Config.SERVER_PORT),
    );
  }
}

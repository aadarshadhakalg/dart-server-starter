import 'dart:async';
import 'dart:io';
import 'package:dartserverstarter/config.dart';
import 'package:dartserverstarter/controller.dart';
import 'package:dartserverstarter/utils/database.dart';
import 'package:postgresql2/pool.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf/shelf_io.dart' as server_io;

export 'dart:io';
export 'package:shelf_hotreload/shelf_hotreload.dart';

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
  Future<void> connectDatabase() async {
    // Establidh Postgresql connection
    // Keep ths in .env later
    String dbUrl =
        'postgres://${Config.DBUSERNAME}:${Config.DBPASSWORD}@${Config.DBHOST}:${Config.DBPORT}/${Config.DBNAME}';
    try {
      Pool pool = Pool(
        dbUrl,
        minConnections: Config.MINPOOLCONNECTION,
        maxConnections: Config.MAXPOOLCONNECTION,
      );
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
    await connectDatabase();
    var handler = MainAppController().coreHandler();
    return await server_io.serve(
      handler,
      Config.SERVER_HOST,
      int.parse(Config.SERVER_PORT),
    );
  }
}

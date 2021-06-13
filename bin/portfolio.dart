import 'dart:io';
import 'package:portfolio/config/config.dart';
import 'package:portfolio/initializer.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';

void main(List<String> args) async {
  HttpServer server;

  withHotreload(() async {
    server = await Initializer().call();
    return server;
  });

  ///Enable content compression
  ///
  /// Uncomment this line in production (recommended)
  /// server.autoCompress = true;

  print(
      'Server started at: http://${ServerConfig.hostname}:${ServerConfig.port}');
}

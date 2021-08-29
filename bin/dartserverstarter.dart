import 'package:dartserverstarter/initializer.dart';

void main(List<String> args) async {
  HttpServer server;

  withHotreload(() async {
    server = await Initializer().call();
    print('Server started at: http://${server.address.host}:${server.port}');
    return server;
  });

  ///Enable content compression
  ///
  /// Uncomment this line in production (recommended)
  /// server.autoCompress = true;
}
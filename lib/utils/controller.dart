import 'package:dartserverstarter/utils/404_handler.dart';
import 'package:shelf_router/shelf_router.dart';

/// Abstract Web Controller Class
abstract class WebController {
  final Router router = Router(notFoundHandler: NotFoundHandler());

  /// Expose 'router' which can be used to register routes and methods.
  Router registerRoute() {
    return router;
  }
}

import 'package:dartserverstarter/utils/404_handler.dart';
import 'package:shelf_router/shelf_router.dart';

/// Abstract Web Controller Class
/// Provides [Router] instance
/// To use [router] override
///
/// ```dart
/// @override
/// Router registerRoute(){
/// router.get('PATH',HANDLER);
/// return super.registerRoute();
/// }
/// ```
abstract class WebController {
  final Router router = Router(notFoundHandler: NotFoundHandler());

  /// Expose 'router' which can be used to register routes and methods.
  Router registerRoute() {
    return router;
  }
}

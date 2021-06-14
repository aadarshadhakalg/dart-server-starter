import 'package:dartserverstarter/core/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class HomeController extends WebController {
  @override
  Router registerRoute() {
    router.get('/', homeViews);
    return super.registerRoute();
  }

  Future<Response> homeViews(request) async {
    return Response.ok('Hello Aadarsha');
  }
}

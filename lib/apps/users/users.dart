import 'dart:async';

import 'package:portfolio/core/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UsersController extends WebController {
  @override
  Router registerRoute() {
    router.get('/', userViews);
    return super.registerRoute();
  }

  Future<Response> userViews(request) async {
    return Response.ok('User Page');
  }
}

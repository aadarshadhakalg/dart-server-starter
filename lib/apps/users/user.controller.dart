import 'dart:async';
import 'package:dartserverstarter/utils/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UsersController extends WebController {
  @override
  Router registerRoute() {
    router.get('/', userViews);
    router.post('/register/', registerUser);
    return super.registerRoute();
  }

  Future<Response> userViews(Request request) async {
    return Response.ok('User Page');
  }

  Future<Response> registerUser(Request request) async {
    
    return Response.ok('Helllo');
  }

  bool validateRequiredField(Map<String, dynamic> payload) {
    return payload.containsKey('username') &&
        payload.containsKey('email') &&
        payload.containsKey('password');
  }
}

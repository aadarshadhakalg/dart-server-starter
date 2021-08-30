import 'dart:async';
import 'package:dartserverstarter/apps/users/user.model.dart';
import 'package:dartserverstarter/apps/users/user.service.dart';
import 'package:dartserverstarter/utils/controller.dart';
import 'package:dartserverstarter/utils/error.dart';
import 'package:shelf/shelf.dart';
import 'package:dartserverstarter/utils/request_extension.dart';
import 'package:shelf_router/shelf_router.dart';

class UsersController extends WebController {
  @override
  Router registerRoute() {
    router.get('/', userViews);
    router.post('/register/', registerUser);
    // router.post('/login', loginUser);
    return super.registerRoute();
  }

  Future<Response> userViews(Request request) async {
    return Response.ok('User Page');
  }

  Future<Response> registerUser(Request request) async {
    late Account account;
    try {
      var payload = await request.data();
      if (validateRequiredField(payload)) {
        payload.putIfAbsent(
            'created_on', () => DateTime.now().millisecondsSinceEpoch);
        account = Account.fromMap(payload);
        account.setPassword(payload['password']);
        await UserServices.instance.insert(account);
        var resp = account.toMap()
          ..removeWhere(
            (key, value) => ['password'].contains(key),
          );

        return Response.ok(resp.toString());
      } else {
        return Response.internalServerError(
            body: 'name,email and password is required');
      }
    } on InvalidDataError catch (e) {
      return Response.internalServerError(body: e.message);
    } catch (e) {
      return Response.internalServerError(body: e);
    }
  }

  // Future<Response> loginUser(Request request) async {
  //   late Account account;

  //   try {
  //     var data = request.data();
  //   } catch (e) {}
  // }

  bool validateRequiredField(Map<String, dynamic> payload) {
    return payload.containsKey('name') &&
        payload.containsKey('email') &&
        payload.containsKey('password');
  }
}

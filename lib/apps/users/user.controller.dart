import 'dart:async';
import 'package:dartserverstarter/apps/authorization/auth_services.dart';
import 'package:dartserverstarter/apps/users/user.model.dart';
import 'package:dartserverstarter/apps/users/user.service.dart';
import 'package:dartserverstarter/utils/abstract_controller.dart';
import 'package:dartserverstarter/utils/error_classes.dart';
import 'package:dartserverstarter/apps/authorization/request_user.dart';
import 'package:shelf/shelf.dart';
import 'package:dartserverstarter/utils/request_extension.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:validators/validators.dart';

class UsersController extends WebController {
  @override
  Router registerRoute() {
    router.get('/', userViews);
    router.post('/register/', registerUser);
    router.post('/login/', loginUser);
    router.patch('/change-password/', changePassword);
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
        Account? dbAccount =
            await UserServices.instance.getAccountByEmail(account.email!);
        var userToken =
            AuthServices.generateJwt(dbAccount!.uid!, dbAccount.roles!);
        return Response.ok(
          {
            'Token': userToken.accessToken,
          }.toString(),
        );
      } else {
        return Response.internalServerError(
          body: 'Bad Request',
        );
      }
    } on InvalidDataError catch (e) {
      return Response.internalServerError(body: e.message);
    } on NoRecordError catch (e) {
      return Response.internalServerError(body: e.message);
    } catch (e) {
      return Response.internalServerError(body: e);
    }
  }

  Future<Response> loginUser(Request request) async {
    late Account? account;
    try {
      var payload = await request.data();
      if (payload.containsKey('email') && payload.containsKey('password')) {
        account =
            await UserServices.instance.getAccountByEmail(payload['email']);
        if (account != null) {
          if (AuthServices.hashPassword(payload['password']) ==
              account.password) {
            return Response.ok(
              {
                'Token': AuthServices.generateJwt(account.uid!, account.roles!),
              }.toString(),
            );
          } else {
            return Response.forbidden('Invalid email or password.');
          }
        } else {
          return Response.notFound('User not found');
        }
      } else {
        return Response.internalServerError(
            body: 'Username and password is mandatory.');
      }
    } catch (e) {
      return Response.internalServerError(
        body: e.toString(),
      );
    }
  }

  Future<Response> changePassword(Request request) async {
    RequestUser user = request.user;
    if (user is AuthenticatedUser) {
      var payload = await request.data();
      if (payload.containsKey('old_password') &&
          payload.containsKey('new_password')) {
        if (payload['old_password'] != payload['new_password']) {
          int id = user.uid;
          Account? account = await UserServices.instance.getAccountByUID(id);
          if (account!.password ==
              AuthServices.hashPassword(payload['old_password'])) {
            await UserServices.instance.changePassword(
              id,
              AuthServices.hashPassword(payload['new_password']),
            );
            return Response.ok('Your Password is Changed');
          } else {
            return Response.forbidden('Old Password didn\'t match.');
          }
        } else {
          return Response.forbidden(
              'Old Password and New Password Cannot be same.');
        }
      } else {
        return Response.internalServerError(
          body: 'old_password and new_password are mandatory.',
        );
      }
    } else {
      return Response.forbidden('You don\'t have permission.');
    }
  }

  bool validateRequiredField(Map<String, dynamic> payload) {
    return payload.containsKey('name') &&
        payload.containsKey('email') &&
        payload.containsKey('password') &&
        isEmail(payload['email']);
  }
}

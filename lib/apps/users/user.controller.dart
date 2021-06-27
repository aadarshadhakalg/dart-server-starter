import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dartserverstarter/apps/users/user.model.dart';
import 'package:dartserverstarter/apps/users/user.service.dart';
import 'package:dartserverstarter/utils/controller.dart';
import 'package:dartserverstarter/utils/utils.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dartserverstarter/utils/request_extension.dart';
import 'package:validators/validators.dart';

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
    try {
      var payload = await request.data();

      return payload.fold(
        (data) async {
          if (validateRequiredField(data)) {

            // Validate Email
            if (!isEmail(data['email'])) {
              return Response.internalServerError(body: 'Invalid Email');
            }

            // Validate Password Strength
            if (data['password'].length < 6) {
              return Response.internalServerError(body: 'Insecure Password');
            }

            // Validate duplicate account 
            if (await UserServices.instance
                .checkForDuplicateEmail(data['email'])) {
              return Response.internalServerError(body: 'Email Already Exists');
            }

            // Hash password
            data['password'] = hashPassword(data['password']);

            // Add to database
            var res = await UserServices.instance.addUser(User.fromMap(data));
            return res.fold(
              (recordedData) =>
                  Response.ok((recordedData?..remove('password')).toString()),
              (error) => Response.internalServerError(body: error.message),
            );
          } else {
            return Response.internalServerError(
                body: 'Missing required fields.');
          }
        },
        (error) => Response.internalServerError(body: error.message),
      );
    } catch (e) {
      return Response.internalServerError(body: e);
    }
  }

  bool validateRequiredField(Map<String, dynamic> payload) {
    return payload.containsKey('username') &&
        payload.containsKey('email') &&
        payload.containsKey('password');
  }
}

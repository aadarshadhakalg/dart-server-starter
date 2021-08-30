import 'dart:convert';
import 'package:dartserverstarter/apps/users/roles.dart';
import 'package:dartserverstarter/utils/error.dart';
import 'package:dartserverstarter/utils/request_user.dart';
import 'package:dartserverstarter/utils/auth_helpers.dart';
import 'package:shelf/src/request.dart';

extension AppRequest on Request {
  Future<Map<String, dynamic>> data() async {
    try {
      return jsonDecode(await readAsString());
    } catch (e) {
      throw InvalidDataError('Invalid Data!');
    }
  }

  RequestUser user() {
    String? tokenFromRequest = headers['Authorization'];
    if (tokenFromRequest == null) {
      return AnonymousUser();
    } else {
      if (tokenFromRequest.substring(0, 6) == 'Bearer') {
        try {
          var jwt = verifyJwt(tokenFromRequest.substring(7));
          int uid = int.parse(jwt!.subject!);
          if (jwt.payload['role'] == Roles.AD.toString()) {
            return AdminUser(uid);
          } else if (jwt.payload['role'] == Roles.ST.toString()) {
            return StaffUser(uid);
          } else if (jwt.payload['role'] == Roles.GU.toString()) {
            return GuestUser(uid);
          } else {
            return AnonymousUser();
          }
        } catch (e) {
          return AnonymousUser();
        }
      } else {
        return AnonymousUser();
      }
    }
  }
}

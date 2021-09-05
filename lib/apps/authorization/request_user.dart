import 'package:shelf/shelf.dart';

import 'auth_services.dart';

/// User role value to store in database, for anyonmous user we use nothing.
enum Roles {
  GU,
  AD,
  ST,
}

/// Define all user level here
abstract class RequestUser {}

class AnonymousUser extends RequestUser {}

abstract class AuthenticatedUser extends RequestUser {
  final int uid;
  AuthenticatedUser(this.uid);
}

class AdminUser extends AuthenticatedUser {
  AdminUser(int uid) : super(uid);
}

class StaffUser extends AuthenticatedUser {
  StaffUser(int uid) : super(uid);
}

class GuestUser extends AuthenticatedUser {
  GuestUser(int uid) : super(uid);
}

/// Extension on Request class to get request user easily
extension AuthRequest on Request {
  RequestUser get user {
    String? tokenFromRequest = headers['Authorization'];
    if (tokenFromRequest == null) {
      return AnonymousUser();
    } else {
      if (tokenFromRequest.substring(0, 6) == 'Bearer') {
        try {
          var jwt = AuthServices.verifyJwt(tokenFromRequest.substring(7));
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

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

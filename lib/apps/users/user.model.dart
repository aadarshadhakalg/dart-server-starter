import 'dart:convert';
import 'package:dartserverstarter/apps/authorization/auth_services.dart';
import 'package:dartserverstarter/apps/authorization/request_user.dart';

class Account {
  int? uid;
  String? name;
  String? password;
  String? email;
  DateTime? created_on;
  DateTime? last_login;
  Roles? roles;
  Account({
    this.uid,
    this.name,
    this.password,
    this.email,
    this.created_on,
    this.last_login,
    this.roles,
  });

  Account copyWith({
    int? uid,
    String? name,
    String? password,
    String? email,
    DateTime? created_on,
    DateTime? last_login,
    Roles? roles,
  }) {
    return Account(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      created_on: created_on ?? this.created_on,
      last_login: last_login ?? this.last_login,
      roles: roles ?? this.roles,
    );
  }

  void setPassword(String password) {
    this.password = AuthServices.hashPassword(password);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'password': password,
      'email': email,
      'created_on': created_on?.millisecondsSinceEpoch,
      'last_login': last_login?.millisecondsSinceEpoch,
      'roles': roles,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      uid: map['uid'],
      name: map['name'],
      password: map['password'],
      email: map['email'],
      created_on: map['created_on'] is DateTime
          ? map['created_on']
          : DateTime.fromMillisecondsSinceEpoch(
              map['created_on'],
            ),
      last_login: DateTime.now(),
      roles: map['roles'] == Roles.AD.toString()
          ? Roles.AD
          : map['roles'] == Roles.ST.toString()
              ? Roles.ST
              : Roles.GU,
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));
}

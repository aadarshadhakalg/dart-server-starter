import 'dart:convert';
import 'package:dartserverstarter/utils/utils.dart';

class Account {
  int? uid;
  String? name;
  String? password;
  String? email;
  DateTime? created_on;
  DateTime? last_login;
  Account({
    this.uid,
    this.name,
    this.password,
    this.email,
    this.created_on,
    this.last_login,
  });

  Account copyWith({
    int? uid,
    String? name,
    String? password,
    String? email,
    DateTime? created_on,
    DateTime? last_login,
  }) {
    return Account(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      created_on: created_on ?? this.created_on,
      last_login: last_login ?? this.last_login,
    );
  }

  void setPassword(String password) {
    this.password = hashPassword(password);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'password': password,
      'email': email,
      'created_on': created_on?.millisecondsSinceEpoch,
      'last_login': last_login?.millisecondsSinceEpoch,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      uid: map['uid'],
      name: map['name'],
      password: map['password'],
      email: map['email'],
      created_on: DateTime.fromMillisecondsSinceEpoch(map['created_on']),
      last_login: DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));
}

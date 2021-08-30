import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dartserverstarter/apps/users/roles.dart';

import '../config.dart';

///Salting is simply the addition of a unique, random string of characters
///known only to the site to each password before it is hashed,
///typically this “salt” is placed in front of each password.
String hashPassword(String password) {
  var _hmacSha1 = Hmac(sha1, utf8.encode(password));
  var salt = utf8.encode(Config.SERVERKEY);
  var digest = _hmacSha1.convert(salt);
  return digest.toString();
}

/// Generates JWT token
String generateJwt(int uid, Roles role) {
  var token = JWT(
    {
      'role': role.toString(),
    },
    subject: uid.toString(),
    issuer: '${Config.SERVER_HOST}',
  );
  String signed = token.sign(
    SecretKey(Config.SERVERKEY),
    expiresIn: Duration(days: 2),
  );
  return signed;
}

/// Verify JWT
JWT? verifyJwt(String token) {
  JWT? jwt;
  try {
    jwt = JWT.verify(token, SecretKey(Config.SERVERKEY));
  } catch (e) {
    print(e);
    rethrow;
  }
  return jwt;
}

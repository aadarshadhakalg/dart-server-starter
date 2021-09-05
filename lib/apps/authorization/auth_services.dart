import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dartserverstarter/apps/authorization/request_user.dart';
import 'package:dartserverstarter/apps/authorization/tokenpair_model.dart';

import '../../config.dart';

class AuthServices {
  ///Salting is simply the addition of a unique, random string of characters
  ///known only to the site to each password before it is hashed,
  ///typically this “salt” is placed in front of each password.
  static String hashPassword(String password) {
    var _hmacSha1 = Hmac(sha1, utf8.encode(password));
    var salt = utf8.encode(Config.SERVERKEY);
    var digest = _hmacSha1.convert(salt);
    return digest.toString();
  }

  /// Generates JWT token
  static TokenPair generateJwt(int uid, Roles role) {
    var token = JWT(
      {
        'role': role.toString(),
      },
      subject: uid.toString(),
      issuer: '${Config.SERVER_HOST}',
    );
    String signedToken = token.sign(
      SecretKey(Config.SERVERKEY),
      expiresIn: Duration(minutes: 5),
    );

    var refToken = JWT(
      {
        'role': role.toString(),
      },
      subject: uid.toString(),
      issuer: '${Config.SERVER_HOST}',
    );
    String signedRefRoken = token.sign(
      SecretKey(Config.SERVERKEY),
      expiresIn: Duration(days: 2),
    );

    return TokenPair(signedToken, signedRefRoken);
  }

  /// Verify JWT
  static JWT? verifyJwt(String token) {
    JWT? jwt;
    try {
      jwt = JWT.verify(token, SecretKey(Config.SERVERKEY));
    } catch (e) {
      print(e);
      rethrow;
    }
    return jwt;
  }
}

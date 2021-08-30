import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

String hashPassword(String password) {
  var _hmacSha1 = Hmac(sha1, utf8.encode('theserverkey'));
  var digest = _hmacSha1.convert(utf8.encode(password));
  print(digest.toString());
  return digest.toString();
}

String generateJwt() {
  var token = JWT(
    {},
    header: {},
    issuer: 'Aadarsha Dhakal',
  );

  var signed = token.sign(SecretKey('key'));

  return '';
}

import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashPassword(String password) {
    var _hmacSha1 = Hmac(sha1, utf8.encode('theserverkey'));
    var digest = _hmacSha1.convert(utf8.encode(password));
    print(digest.toString());
    return digest.toString();
  }
import 'dart:convert';

import 'package:dartserverstarter/utils/error.dart';
import 'package:shelf/src/request.dart';

extension AppRequest on Request {
  Future<Map<String, dynamic>> data() async {
    try {
      return jsonDecode(await readAsString());
    } catch (e) {
      throw InvalidDataError('Invalid Data!');
    }
  }
}

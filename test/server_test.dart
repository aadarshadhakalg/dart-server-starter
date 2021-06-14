import 'package:dio/dio.dart';
import 'package:test/test.dart';

void main() {
  test('Should return 200 while accessing home route', () async {
    final dio = Dio();
    var resp = await dio.get('http://localhost:8080');
    expect(resp.statusCode, 200);
  });
}

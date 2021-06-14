import 'package:mongo_dart/mongo_dart.dart';

class DatabaseSetupConnection {
  DatabaseSetupConnection._internal();
  static DatabaseSetupConnection? _instance;
  static DatabaseSetupConnection get instance {
    return _instance ??= DatabaseSetupConnection._internal();
  }

  String? address;
  Db? db;

  void uriString(String uriString) {
    address = uriString;
  }

  Future<Db?> connect() async {
    var db = Db(address!);
    try {
      await db.open();
      return db;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

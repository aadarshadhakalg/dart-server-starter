import 'package:dartserverstarter/apps/users/user.model.dart';
import 'package:dartserverstarter/utils/database.dart';
import 'package:dartserverstarter/utils/error.dart';
import 'package:postgresql2/postgresql.dart';

class UserServices {
  static UserServices? _instance;
  UserServices._internal();
  static UserServices get instance => _instance ??= UserServices._internal();

  Future<void> insert(Account user) async {
    String command = '''
    INSERT INTO public.accounts
    ("name", "password", email, created_on, last_login)
    VALUES('${user.name}', '${user.password}', '${user.email}', '${DateTime.now()}', '${DateTime.now()}')
    ''';

    try {
      var res = await database.execute(command);
      print(res);
    } on PostgresqlException catch (e) {
      if (e.serverMessage?.code == '23505') {
        throw InvalidDataError('User Account Already Exists');
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<Account?> getAccountByEmail(String email) async {
    String command = "SELECT * FROM public.accounts WHERE email = \'$email\';";

    Row userRow;
    var rows = await database.query(command).toList();
    if (rows.isNotEmpty) {
      userRow = rows.first;
      return Account.fromMap(
        Map<String, dynamic>.from(
          userRow.toMap(),
        ),
      );
    } else {
      throw NoRecordError('Account Not Found with provided email');
    }
  }

  Future<Account?> getAccountByUID(int uid) async {
    String command = 'SELECT * FROM public.accounts WHERE uid = $uid;';

    Row userRow;
    var rows = await database.query(command).toList();
    if (rows.isNotEmpty) {
      userRow = rows.first;
      return Account.fromMap(
        Map<String, dynamic>.from(
          userRow.toMap(),
        ),
      );
    } else {
      throw NoRecordError('Account Not Found with provided uid');
    }
  }

  Future<bool> changePassword(int uid, String newPassword) async {
    String command =
        'UPDATE public.accounts SET "password"=\'$newPassword\' WHERE uid=40;';

    var affected = await database.execute(command);
    if (affected == 1) {
      return true;
    } else {
      return false;
    }
  }
}

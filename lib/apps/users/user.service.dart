import 'package:dartserverstarter/apps/users/user.model.dart';
import 'package:dartserverstarter/initializer.dart';
import 'package:dartserverstarter/utils/database.dart';

class UserServices {
  static UserServices? _instance;
  UserServices._internal();
  static UserServices get instance => _instance ??= UserServices._internal();

  void insert(User user) {
    String command = '''
INSERT INTO public.accounts
("name", "password", email, created_on, last_login)
VALUES('${user.username}', '${user.password}', '${user.email}', '${DateTime.now()}', '${DateTime.now()}')
    ''';

    database.execute(command).then((value) => stdout.write);
  }
}

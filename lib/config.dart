class Config {
  /// SERVER CONFIG
  static const bool ENABLE_HOT_RELOAD = false;
  static const String SERVER_HOST = '0.0.0.0';
  static const String SERVER_PORT = '8000';
  static const bool PRODUCTION = false;

  /// POSTGRES CONFIG
  static const String DBUSERNAME = 'aadarsha';
  static const String DBPASSWORD = 'ad';
  static const String DBHOST = 'db';
  static const String DBPORT = '5432';
  static const String DBNAME = 'aadarsha';
  static const int MINPOOLCONNECTION = 2;
  static const int MAXPOOLCONNECTION = 5;

  /// This should be random String
  /// It's used as a salt in password hashing and secret key for JWT Token
  static const String SERVERKEY = 'Xusia7fsdf9sfyshHfhgfusydgfisfkfs';
}

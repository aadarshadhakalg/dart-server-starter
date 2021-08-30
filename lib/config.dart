class Config {
  /// SERVER CONFIG
  static const bool ENABLE_HOT_RELOAD = false;
  static const String SERVER_HOST = '127.0.0.1';
  static const String SERVER_PORT = '8080';
  static const bool PRODUCTION = false;

  /// POSTGRES CONFIG
  static const String DBUSERNAME = 'aadarsha';
  static const String DBPASSWORD = 'ad';
  static const String DBHOST = 'localhost';
  static const String DBPORT = '5432';
  static const String DBNAME = 'aadarsha';
  static const int MINPOOLCONNECTION = 2;
  static const int MAXPOOLCONNECTION = 5;
}

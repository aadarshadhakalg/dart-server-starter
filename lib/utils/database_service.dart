import 'dart:io';

import 'package:postgresql2/pool.dart';
import 'package:postgresql2/postgresql.dart';
import 'package:redis/redis.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  Future<void> startPostGres({
    required String dbusername,
    required String dbpassword,
    required String dbhost,
    required String dbport,
    required String dbname,
    required int minPool,
    required int maxPool,
  }) async {
    // Establidh Postgresql connection
    // Keep ths in .env later
    String dbUrl = 'postgres://$dbusername:$dbpassword@$dbhost:$dbport/$dbname';
    try {
      Pool pool = Pool(
        dbUrl,
        minConnections: minPool,
        maxConnections: maxPool,
      );
      await pool.start();
      database = await pool.connect();
      stdout.write('Postgres Connection Established Successfully');
    } catch (e) {
      stderr.write(e);
      exit(1);
    }
  }

  Future<void> startRedis(String redishost, String redisport) async {
    try {
      redisCache = await RedisConnection().connect(redishost, redisport);
      stdout.write('Redis Connection Established Successfully');
    } catch (e) {
      stdout.write(e);
    }
  }

  late Connection database;
  late Command redisCache;
}

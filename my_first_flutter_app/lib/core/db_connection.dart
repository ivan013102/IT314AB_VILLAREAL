import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DbConnection {
  DbConnection._();

  static Connection? _connection;
  static bool _verified = false;

  static Future<Connection> get connection async {
    if (_connection == null || !_connection!.isOpen) {

      // We use replaceAll to strip out "DB_HOST=" if it accidentally gets included in the string
      String rawHost = dotenv.env['DB_HOST'] ?? '';
      String cleanHost = rawHost.replaceAll('DB_HOST=', '').trim();

      _connection = await Connection.open(
        Endpoint(
          host: cleanHost,
          port: int.parse(dotenv.env['DB_PORT']?.trim() ?? '5432'),
          database: dotenv.env['DB_NAME']?.trim() ?? '',
          username: dotenv.env['DB_USER']?.trim() ?? '',
          password: dotenv.env['DB_PASSWORD']?.trim() ?? '',
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.require,
          connectTimeout: Duration(seconds: 30),
          queryMode: QueryMode.simple, // Required for the -pooler
        ),
      );
    }
    return _connection!;
  }

  static Future<bool> verify() async {
    try {
      final conn = await connection;
      final result = await conn.execute('SELECT 1 AS ok');
      _verified = result.isNotEmpty;
      return _verified;
    } catch (e) {
      _verified = false;
      rethrow;
    }
  }

  static bool get isVerified => _verified;

  static Future<void> close() async {
    if (_connection != null && _connection!.isOpen) {
      await _connection!.close();
    }
    _connection = null;
    _verified = false;
  }
}
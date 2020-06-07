import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Database {
  static Future<sembast.Database> get _db async {
    final dir = await getApplicationSupportDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'my_database.db');
    return await databaseFactoryIo.openDatabase(dbPath);
  }

  static Future<String> get token async {
    final db = await _db;
    final store = sembast.StoreRef.main();
    if (await store.record('token').exists(db)) {
      return await store.record('token').get(db);
    }

    return '';
  }
}
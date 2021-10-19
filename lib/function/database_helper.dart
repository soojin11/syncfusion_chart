import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final _databaseName = "config_wr.db";
  static final _databaseVersion = 1;
  static final table = 'info';
  static final name = 'Name';
  static final value = 'Value';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  var databaseFactory = databaseFactoryFfi;
  static Database? db;
  Future<Database?> get database async {
    // print("database");
    if (db != null) return db;
    db = await _initDatabase();
    return db;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    db = await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            onCreate: _onCreate, version: _databaseVersion));
    if (db == null) print('_initDatabase db가 널이네');
    return db!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE info (Name String, Value INTEGER)");
    List<Map<String, dynamic>> values = [];
    for (var i = 0; i < 5; i++) {
      values.add({
        "name": "$i-start",
        "value": 1,
      });
      values.add({
        "name": "$i-end",
        "value": 1,
      });
    }
    values.add({
      "name": "integrationTime",
      "value": 20,
    });
    values.add({
      "name": "interval",
      "value": 100,
    });
    values.add({
      "name": "sampling",
      "value": 500,
    });
    values.add({
      "name": "serialPort",
      "value": "COM1",
    });
    values.add({
      "name": "hemos",
      "value": 1,
    });
    values.add({
      "name": "oes",
      "value": 1,
    });
    for (var i = 0; i < values.length; i++) {
      Map<String, dynamic> row = {
        name: values[i]["name"],
        value: values[i]["value"],
      };
      await db.insert(table, row);
    }
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? database = await instance.database;
    return await database!.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? database = await instance.database;
    String name = row["Name"];
    return await database!
        .update(table, row, where: 'Name = ?', whereArgs: [name]);
  }
}

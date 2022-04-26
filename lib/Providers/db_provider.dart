import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sql.dart';
import '../Model/models.dart';

class DBProvider {
  static Database? _database;
  static const _dbName = 'maps.db';
  final _versionDB = 1;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Database database = await openDatabase(
        join(await getDatabasesPath(), _dbName),
        version: _versionDB, onCreate: (Database database, int version) async {
      await database.execute('''
            CREATE TABLE "Markers" (
            "Id"    INTEGER,
            "Title"    TEXT NOT NULL,
            "Description" TEXT NOT NULL,
            "Latitude" NUMERIC NOT NULL,
            "Longitude" NUMERIC NOT NULL,
            PRIMARY KEY("Id" AUTOINCREMENT)
            );
          ''');
    });
    return database;
  }

  Future<List<MarkerMap>> getMarkers() async {
    try {
      final db = await database;
      final res = await db.query('Markers', orderBy: 'Id');
      return res.map((e) => MarkerMap.fromMap(e)).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  void addMarkerDB(MarkerMap value) async {
    try {
      final db = await database;
      final res = await db.insert('Markers', value.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('ADD MARKER: $e');
    }
  }

  void removeMarkerDB(MarkerMap value) async {
    try {
      final db = await database;
      final res = await db.delete('Markers', where: 'Id = ?', whereArgs: [value.id]);
    } catch (e) {
      print('REMOVE MARKER: $e');
    }
  }

  Future<int?> getMarkersCount() async {
    try {
      final db = await database;
      final res = await db.rawQuery('SELECT COUNT(*) FROM Markers');
      return Sqflite.firstIntValue(res);
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }
}

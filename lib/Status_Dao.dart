import 'package:sqflite/sqflite.dart';
import 'DatabaseHelper.dart';
import 'Status.dart';

class StatusDAO {
  final dbHelper = Databasehelper();

  Future<int> inserir(Status status) async {
    final db = await dbHelper.database;
    return await db.insert('status', status.toMap());
  }

  Future<List<Status>> listar() async {
    final db = await dbHelper.database;
    final maps = await db.query('status');
    return maps.map((e) => Status.fromMap(e)).toList();
  }
}

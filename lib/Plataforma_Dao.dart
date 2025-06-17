import 'package:sqflite/sqflite.dart';
import 'DatabaseHelper.dart';
import 'Plataforma.dart';

class PlataformaDAO {
  final dbHelper = Databasehelper();

  Future<int> inserir(Plataforma plataforma) async {
    final db = await dbHelper.database;
    return await db.insert('plataforma', plataforma.toMap());
  }

  Future<List<Plataforma>> listar() async {
    final db = await dbHelper.database;
    final maps = await db.query('plataforma');
    return maps.map((e) => Plataforma.fromMap(e)).toList();
  }
}

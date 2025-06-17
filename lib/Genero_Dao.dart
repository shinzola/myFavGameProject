import 'package:sqflite/sqflite.dart';
import 'DatabaseHelper.dart';
import 'Genero.dart';

class GeneroDAO {
  final dbHelper = Databasehelper();

  Future<int> inserir(Genero genero) async {
    final db = await dbHelper.database;
    return await db.insert('genero', genero.toMap());
  }

  Future<List<Genero>> listar() async {
    final db = await dbHelper.database;
    final maps = await db.query('genero');
    return maps.map((e) => Genero.fromMap(e)).toList();
  }
}

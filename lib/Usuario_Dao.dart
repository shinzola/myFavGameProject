import 'package:sqflite/sqflite.dart';
import 'DatabaseHelper.dart';
import 'Usuario.dart';

class UsuarioDAO {
  final dbHelper = Databasehelper();

  Future<int> inserir(Usuario usuario) async {
    final db = await dbHelper.database;
    return await db.insert('usuario', usuario.toMap());
  }

  Future<Usuario?> buscarPorEmail(String email) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'usuario',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Usuario>> listar() async {
    final db = await dbHelper.database;
    final maps = await db.query('usuario');
    return maps.map((e) => Usuario.fromMap(e)).toList();
  }

  Future<int> atualizar(Usuario usuario) async {
    final db = await dbHelper.database;
    return await db.update(
      'usuario',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await dbHelper.database;
    return await db.delete('usuario', where: 'id = ?', whereArgs: [id]);
  }
}

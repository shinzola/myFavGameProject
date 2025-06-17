import 'package:sqflite/sqflite.dart';
import 'DatabaseHelper.dart';
import 'Jogo.dart';

class JogoDAO {
  final dbHelper = Databasehelper();

  Future<int> inserir(Jogo jogo) async {
    final db = await dbHelper.database;
    return await db.insert('jogo', jogo.toMap());
  }

  Future<List<Jogo>> listarPorUsuario(int usuarioId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'jogo',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );
    return maps.map((e) => Jogo.fromMap(e)).toList();
  }

  Future<int> atualizar(Jogo jogo) async {
    final db = await dbHelper.database;
    return await db.update(
      'jogo',
      jogo.toMap(),
      where: 'id = ?',
      whereArgs: [jogo.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await dbHelper.database;
    return await db.delete('jogo', where: 'id = ?', whereArgs: [id]);
  }
}

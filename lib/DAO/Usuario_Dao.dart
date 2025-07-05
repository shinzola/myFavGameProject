import 'package:sqflite/sqflite.dart';
import '../Database/DatabaseHelper.dart';
import '../Classes/Usuario.dart';

class UsuarioDAO {
  final dbHelper = Databasehelper();

  Future<int> inserir(Usuario usuario) async {
    final db = await dbHelper.database;

    // Verifica se já existe um usuário com o mesmo e-mail
    final List<Map<String, dynamic>> existingUsers = await db.query(
      'usuario',
      where: 'email = ?',
      whereArgs: [usuario.email],
    );

    if (existingUsers.isNotEmpty) {
      // Já existe usuário com esse e-mail
      return -1;
    }

    // Se não existe, insere normalmente
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

  Future<Usuario?> autenticar(String email, String senha) async {
    final db = await Databasehelper.instance.database;

    final resultado = await db.query(
      'usuario',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (resultado.isNotEmpty) {
      return Usuario.fromMap(resultado.first);
    } else {
      return null;
    }
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

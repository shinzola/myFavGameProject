import '../Database/DatabaseHelper.dart';
import '../Classes/Jogo.dart';

class JogoDAO {
  final dbHelper = Databasehelper();
  Future<int> inserir(Jogo jogo) async {
    final db = await dbHelper.database;

    // Verifica se já existe um jogo com o mesmo id e usuario_id
    final List<Map<String, dynamic>> existingGames = await db.query(
      'jogo',
      where: 'nome = ? AND usuario_id = ?',
      whereArgs: [jogo.nome, jogo.usuarioId],
    );

    if (existingGames.isNotEmpty) {
      // Já existe o jogo vinculado ao usuário
      return -1; // Indica duplicação
    }

    // Se não existe, insere normalmente
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

  Future<int> deletar(int id) async {
    final db = await dbHelper.database;
    return await db.delete('jogo', where: 'id = ?', whereArgs: [id]);
  }
}

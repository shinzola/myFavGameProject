import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper {
  static final Databasehelper _instance = Databasehelper._internal();
  static Database? _database;
  factory Databasehelper() {
    return _instance;
  }
  Databasehelper._internal();
  static Databasehelper get instance => _instance;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'myfavgame.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS usuario(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, email TEXT NOT NULL, senha TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE IF NOT EXISTS jogo(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, imagem TEXT, genero TEXT, usuario_id INTEGER NOT NULL, FOREIGN KEY (usuario_id) REFERENCES Usuario(id))',
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

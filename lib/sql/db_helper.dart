import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.getInstance();
  DatabaseHelper.getInstance();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();

    return _db;
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'conquali.db');
    print("db $path");

    var db = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE funcao(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, status BOOL, created TEXT NOT NULL)');
    await db.execute('CREATE TABLE funcionario(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, funcao INTEGER NOT NULL, status BOOL, FOREIGN KEY(funcao) REFERENCES funcao(id), created TEXT NOT NULL)');
    await db.execute('CREATE TABLE equipe(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, status BOOL, created TEXT NOT NULL)');
    await db.execute('CREATE TABLE equipe_funcionario(id INTEGER PRIMARY KEY AUTOINCREMENT, equipe INTEGER NOT NULL, funcionario INTEGER NOT NULL, created TEXT NOT NULL, FOREIGN KEY(equipe) REFERENCES equipe(id), FOREIGN KEY(funcionario) REFERENCES funcionario(id) )');
    await db.execute('CREATE TABLE local(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, status BOOL, created TEXT NOT NULL)');
    await db.execute('CREATE TABLE item(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, status BOOL, created TEXT NOT NULL)');
    await db.execute('CREATE TABLE servico(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, status BOOL, created TEXT NOT NULL)');
    await db.execute('CREATE TABLE servico_item(id INTEGER PRIMARY KEY AUTOINCREMENT, servico INTEGER NOT NULL, item INTEGER NOT NULL, created TEXT NOT NULL, FOREIGN KEY(servico) REFERENCES servico(id), FOREIGN KEY(item) REFERENCES item(id) )');
    await db.execute('CREATE TABLE inspecao(id INTEGER PRIMARY KEY AUTOINCREMENT, local INTEGER NOT NULL, equipe INTEGER NOT NULL, created TEXT NOT NULL)');
    await db.execute('CREATE TABLE inspecao_servico_item(id INTEGER PRIMARY KEY AUTOINCREMENT, inspecao INTEGER NOT NULL, servico_item INTEGER NOT NULL, conforme BOOL NOT NULL, obs TEXT, created TEXT NOT NULL, FOREIGN KEY(inspecao) REFERENCES inspecao(id), FOREIGN KEY(servico_item) REFERENCES servico_item(id))');
  }

  Future<FutureOr<void>> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    if(oldVersion == 1 && newVersion == 2) {
      //await db.execute("alter table ACTIVITY add column NOVA TEXT");
    }
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}

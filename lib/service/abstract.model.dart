import 'package:sqflite/sqflite.dart';
import 'package:conquali_flutter/application.dart';

abstract class AbstractModel {
  Database _db;

  String get dbname;

  int get dbversion;

  Future<Database> init() async {
    if(this._db == null) {
      var databasePath = await getDatabasesPath();
      String  path = databasePath+dbname;

      this._db = await openDatabase(
        path, 
        version: dbversion,
        onCreate:(Database db, int version) async {

          //Executa script para criar estrutura da base
          dbCreate.forEach((String sql) {
            db.execute(sql);
          });

      });
    }
    return this._db;
  }

  Future<Database> getDb() async {
    return await this.init();
  }

  Future<List<Map>> list();

  Future<Map> getItem(dynamic where);

  Future<int> insert(Map<String, dynamic> values);
  
  Future<bool> update(Map<String, dynamic> values, dynamic where);

  Future<bool> delete(dynamic id);

  void close() async {
    if(this._db != null) {
      await this._db.close();
      this._db = null;
    }
  }
}
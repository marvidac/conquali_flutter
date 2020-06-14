import 'package:conquali_flutter/service/abstract.model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:conquali_flutter/application.dart';
import 'abstract.model.dart';

class FuncionarioService extends AbstractModel {

  static FuncionarioService _this;
  static final _table = 'funcionario';

  factory FuncionarioService() {
    if(_this ==null) {
      _this = FuncionarioService.getInstance();
    }

    return _this;
  }

  FuncionarioService.getInstance() : super();

  @override
  String get dbname => dbName;

  @override
  
  int get dbversion => dbVersion;

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    //Caso precise pode usar rawQuery para custom query 
    return db.query(_table, orderBy: 'created DESC');
  }

  @override
  Future<bool> delete(id) async {
    Database db = await this.getDb();
    int rows = await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    
    return (rows != 0);
  }

  @override
  Future<Map> getItem(where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query(_table, where: 'id = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if(items.isNotEmpty) {
      result = items.first;
    }

    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getDb();
    int newId = await db.insert(_table, values);
  
    return newId;
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {
    Database db = await this.getDb();
    int rows = await db.update(_table, values, where: 'id = ?', whereArgs: [where] );

    return (rows != 0);
  }
 

}
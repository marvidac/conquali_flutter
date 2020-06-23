import 'package:conquali_flutter/dao/generic_dao.dart';
import 'package:conquali_flutter/model/funcao.dart';

class FuncaoDao extends GenericDao<Funcao> {
  @override
  String get tableName => "funcao";

  @override
  Funcao fromMap(Map<String, dynamic> map) {
    return Funcao.fromMap(map);
  }

  Future<List<Funcao>> findAllByStatus(bool status) {
    int done = status ? 1 : 0;
    return query('select * from $tableName where status = ?', [done]);
  }

}
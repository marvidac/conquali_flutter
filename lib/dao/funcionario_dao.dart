import 'package:conquali_flutter/dao/generic_dao.dart';
import 'package:conquali_flutter/model/funcionario.dart';

class FuncionarioDao extends GenericDao<Funcionario> {
  @override
  String get tableName => "funcionario";

  @override
  Funcionario fromMap(Map<String, dynamic> map) {
    return Funcionario.fromMap(map);
  }

  Future<List<Funcionario>> findAllByStatus(bool status) {
    int done = status ? 1 : 0;
    return query('select * from $tableName where status = ?', [done]);
  }

}
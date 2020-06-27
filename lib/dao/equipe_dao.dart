import 'package:conquali_flutter/dao/generic_dao.dart';
import 'package:conquali_flutter/model/equipe.dart';
import 'package:conquali_flutter/model/equipe_funcionario.dart';

class EquipeDao extends GenericDao<Equipe> {
  @override
  String get tableName => "equipe";

  @override
  Equipe fromMap(Map<String, dynamic> map) {
    return Equipe.fromMap(map);
  }

  Future<List<Equipe>> findAllByStatus(bool status) {
    int done = status ? 1 : 0;
    return query('select * from $tableName where status = ?', [done]);
  }

  Future<int> save(Equipe entity, List<EquipeFuncionario> funcionarios) async {
    super.save(entity);

    return null;
  }
}

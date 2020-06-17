import 'package:conquali_flutter/dao/generic_dao.dart';
import 'package:conquali_flutter/model/equipe_funcionario.dart';

class EquipeFuncionarioDao extends GenericDao<EquipeFuncionario> {
  @override
  String get tableName => "equipe_funcionario";

  @override
  EquipeFuncionario fromMap(Map<String, dynamic> map) {
    return EquipeFuncionario.fromMap(map);
  }

  Future<List<EquipeFuncionario>> findAllByEquipe(int equipe) {
    return query("""
      select * from $tableName ef
        INNER JOIN equipe eq ON eq.id = ef.equipe
        INNER JOIN funcionario fu ON fu.id = ef.funcionario
      where equipe = ?
    """, [equipe]);
  }

}
import 'package:conquali_flutter/sql/entity.dart';
import 'dart:convert' as convert;

class EquipeFuncionario extends Entity {
  int id;
  int equipe;
  int funcionario;
  String created;

  EquipeFuncionario({this.id, this.equipe, this.funcionario, this.created});

  factory EquipeFuncionario.fromMap(Map<String, dynamic> json) =>
      new EquipeFuncionario(
        id: json["id"],
        equipe: json["equipe"],
        funcionario: json["funcionario"],
        created: json["created"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "equipe": equipe,
        "funcionario": funcionario,
        "created": created,
      };

  @override
  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }
}

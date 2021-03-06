import 'package:conquali_flutter/sql/entity.dart';
import 'dart:convert' as convert;

class Funcionario extends Entity {
  int id;
  String nome;
  int funcao;
  bool status;
  String created;

  Funcionario({
    this.id,
    this.nome,
    this.funcao,
    this.status,
    this.created
  });

  factory Funcionario.fromMap(Map<String, dynamic> json) => new Funcionario(
        id: json["id"],
        nome: json["nome"],
        funcao: json["funcao"],
        status: json["status"]==1?true:false,
        created: json["created"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nome": nome,
        "funcao": funcao,
        "status": status,
        "created": created,
   };

   @override
  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }
  
}

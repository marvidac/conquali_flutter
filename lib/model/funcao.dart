import 'package:conquali_flutter/sql/entity.dart';
import 'dart:convert' as convert;

class Funcao extends Entity {
  int id;
  String nome;
  bool status;
  String created;

  Funcao({
    this.id,
    this.nome,
    this.status,
    this.created
  });

  factory Funcao.fromMap(Map<String, dynamic> json) => new Funcao(
        id: json["id"],
        nome: json["nome"],
        status: json["status"]==1?true:false,
        created: json["created"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nome": nome,
        "status": status,
        "created": created,
   };

   @override
  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }
  
}

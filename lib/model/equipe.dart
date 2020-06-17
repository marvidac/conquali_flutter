import 'package:conquali_flutter/sql/entity.dart';
import 'dart:convert' as convert;

class Equipe extends Entity {
  int id;
  String nome;
  bool status;
  String created;

  Equipe({
    this.id,
    this.nome,
    this.status,
    this.created
  });

  factory Equipe.fromMap(Map<String, dynamic> json) => new Equipe(
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

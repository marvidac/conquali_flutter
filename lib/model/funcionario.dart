class Funcionario {
  int id;
  String nome;
  bool status;
  String created;

  Funcionario({
    this.id,
    this.nome,
    this.status,
    this.created
  });

  factory Funcionario.fromMap(Map<String, dynamic> json) => new Funcionario(
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
  
}

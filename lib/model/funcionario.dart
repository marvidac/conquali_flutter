class Funcionario {
  int id;
  String nome;
  bool status;

  Funcionario({
    this.id,
    this.nome,
    this.status,
  });

  factory Funcionario.fromMap(Map<String, dynamic> json) => new Funcionario(
        id: json["id"],
        nome: json["nome"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nome": nome,
        "status": status,
      };
  
}

class MedicoData{
  String? nome;
  int? crm;
  String? especialidade;
  String? telefone;
  String? email;

  MedicoData({
    this.nome,
    this.crm,
    this.especialidade,
    this.telefone,
    this.email
  });

  factory MedicoData.fromJson(Map<String, dynamic> json) {
    return MedicoData(
        nome: json['nome'],
        crm: json['crm'],
        especialidade: json['especialidade'],
        telefone: json['telefone'],
        email: json['email']
    );
  }
}
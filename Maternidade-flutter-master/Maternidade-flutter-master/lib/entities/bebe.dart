
class BebeData{
  int? id;
  int? crm_medico;
  int? id_mae;
  String? nome;
  String? data_nascimento;
  int? peso;
  int? altura;

  BebeData({
    this.id,
    this.nome,
    this.crm_medico,
    this.id_mae,
    this.data_nascimento,
    this.peso,
    this.altura
  });

  factory BebeData.fromJson(Map<String, dynamic> json) {
    return BebeData(
        id: json['id bebe'],
        id_mae: json['id mae'],
        crm_medico: json['crm'],
        nome: json['nome'],
        data_nascimento: json['data_nascimento'],
        peso: json['peso'],
        altura: json['altura']
    );
  }
}
class Plataforma {
  int? id;
  String nome;

  Plataforma({this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome};
  }

  factory Plataforma.fromMap(Map<String, dynamic> map) {
    return Plataforma(id: map['id'], nome: map['nome']);
  }
}

class Genero {
  int? id;
  String nome;

  Genero({this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome};
  }

  factory Genero.fromMap(Map<String, dynamic> map) {
    return Genero(id: map['id'], nome: map['nome']);
  }
}

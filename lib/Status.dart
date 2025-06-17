class Status {
  int? id;
  String nome;

  Status({this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome};
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(id: map['id'], nome: map['nome']);
  }
}

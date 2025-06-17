class Jogo {
  int? id;
  String nome;
  String descricao;
  String imagem;
  double nota;
  String dataLancamento;
  int generoId;
  int plataformaId;
  int statusId;
  int usuarioId;

  Jogo({
    this.id,
    required this.nome,
    required this.descricao,
    required this.imagem,
    required this.nota,
    required this.dataLancamento,
    required this.generoId,
    required this.plataformaId,
    required this.statusId,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'imagem': imagem,
      'nota': nota,
      'data_lancamento': dataLancamento,
      'genero_id': generoId,
      'plataforma_id': plataformaId,
      'status_id': statusId,
      'usuario_id': usuarioId,
    };
  }

  factory Jogo.fromMap(Map<String, dynamic> map) {
    return Jogo(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      imagem: map['imagem'],
      nota: map['nota'],
      dataLancamento: map['data_lancamento'],
      generoId: map['genero_id'],
      plataformaId: map['plataforma_id'],
      statusId: map['status_id'],
      usuarioId: map['usuario_id'],
    );
  }
}

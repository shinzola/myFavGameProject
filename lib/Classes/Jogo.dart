class Jogo {
  int? id;
  String nome;
  String imagem;
  int usuarioId;

  Jogo({
    this.id,
    required this.nome,
    required this.imagem,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'imagem': imagem, 'usuario_id': usuarioId};
  }

  factory Jogo.fromMap(Map<String, dynamic> map) {
    return Jogo(
      id: map['id'],
      nome: map['nome'],
      imagem: map['imagem'],
      usuarioId: map['usuario_id'],
    );
  }
}

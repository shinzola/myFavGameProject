class GameAPI {
  final int id;
  final String nome;
  final String imagem;
  final List<String> generos;

  GameAPI({
    required this.id,
    required this.nome,
    required this.imagem,
    required this.generos,
  });

  factory GameAPI.fromMap(Map<String, dynamic> json) {
    String limparTexto(String texto) {
      return texto
          .replaceAll('â€™', "'")
          .replaceAll('â€“', '-')
          .replaceAll('Ã©', 'é')
          .replaceAll('Ã¡', 'á')
          .replaceAll('Ã§', 'ç')
          .replaceAll('Ãº', 'ú');
    }

    return GameAPI(
      id: json['id'],
      nome: limparTexto(json['name'] ?? 'Sem nome'),
      imagem: json['background_image'] ?? '',
      generos:
          (json['genres'] as List<dynamic>?)
              ?.map((genre) => genre['name'].toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nome,
      'background_image': imagem,
      'genres': generos,
    };
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'GameAPI.dart';

class ApiService {
  final String _baseUrl = 'https://api.rawg.io/api';
  final String _apiKey = 'a9e59fadecfc4b5db318c480d5925848';

  Future<List<GameAPI>> fetchGames({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/games?key=$_apiKey&page=$page'),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(decodedBody);
      List<GameAPI> games = (jsonData['results'] as List)
          .map((gameJson) => GameAPI.fromMap(gameJson))
          .toList();
      return games;
    } else {
      throw Exception('Erro ao carregar jogos');
    }
  }

  Future<List<GameAPI>> searchGames(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/games?key=$_apiKey&search=$query'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['results'];
      return data.map((json) => GameAPI.fromMap(json)).toList();
    } else {
      throw Exception('Erro ao buscar jogos: ${response.statusCode}');
    }
  }
}

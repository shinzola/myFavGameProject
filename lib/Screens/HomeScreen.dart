import 'package:flutter/material.dart';
import 'package:myfavgame/API/GameServiceAPI.dart';
import 'package:myfavgame/API/GameAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'package:myfavgame/Classes/Jogo.dart';
import 'package:myfavgame/DAO/Jogo_Dao.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_id');
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => const Login()));
  }

  final ScrollController _gameListScrollController = ScrollController();
  Set<String> _favoritosIds = {};
  String? _filtroGenero;
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final ApiService apiService = ApiService();
  List<GameAPI> _games = [];
  int _currentPage = 1;
  int _totalPages = 10;
  TextEditingController _searchController = TextEditingController();
  List<GameAPI> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Future<void> _searchGames() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<GameAPI> results = await apiService.searchGames(
        _searchController.text,
      );
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao buscar jogos: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioId = prefs.getInt('usuario_id') ?? 0;

    final jogoDAO = JogoDAO();
    final jogosFavoritos = await jogoDAO.listarPorUsuario(usuarioId);

    setState(() {
      _usuarioId = usuarioId;
      _favoritosIds = jogosFavoritos.map((jogo) => jogo.nome).toSet();
    });
  }

  String _nome = '';
  String _email = '';
  int? _usuarioId;
  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
    _carregarFavoritos();
    _fetchGames(_currentPage);
  }

  Future<void> _carregarDadosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('usuario_id');
    final nome = prefs.getString('usuario_nome');
    final email = prefs.getString('usuario_email');

    setState(() {
      _usuarioId = id;
      _nome = nome ?? 'Nome não encontrado';
      _email = email ?? 'Email não encontrado';
    });
  }

  Future<void> _fetchGames(int page) async {
    List<GameAPI> newGames = await apiService.fetchGames(page: page);
    setState(() {
      _games = newGames;
      _currentPage = page;
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildGameList(),
          SearchScreen(),
          _buildFavoritosScreen(),
          _buildPerfilScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Jogos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildGameList() {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Jogos'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24.0),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (String generoSelecionado) {
              setState(() {
                _filtroGenero = generoSelecionado == 'Todos'
                    ? null
                    : generoSelecionado;
              });
            },
            itemBuilder: (BuildContext context) {
              final generos = ['Todos', 'Action', 'Indie', 'Adventure', 'RPG'];
              return generos.map((String genero) {
                return PopupMenuItem<String>(
                  value: genero,
                  child: Text(genero),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _games.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // LISTA DE JOGOS (GRID)
                Expanded(
                  child: GridView.builder(
                    controller: _gameListScrollController,
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: _games.length,
                    itemBuilder: (context, index) {
                      final game = _games[index];
                      String generosFormatados = game.generos.join(', ');

                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // IMAGEM + FAVORITO
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: SizedBox(
                                    height: 180,
                                    child: game.imagem.isNotEmpty
                                        ? Image.network(
                                            game.imagem,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                                  color: Colors.grey[800],
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ),
                                          )
                                        : Container(
                                            color: Colors.grey[800],
                                            child: const Center(
                                              child: Icon(
                                                Icons.videogame_asset,
                                                color: Colors.grey,
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      if (_usuarioId != null) {
                                        final jogoDAO = JogoDAO();
                                        final nome = game.nome;

                                        final jaFavoritado = _favoritosIds
                                            .contains(nome);

                                        if (jaFavoritado) {
                                          // Remover dos favoritos
                                          final jogosUsuario = await jogoDAO
                                              .listarPorUsuario(_usuarioId!);
                                          final jogoParaRemover = jogosUsuario
                                              .firstWhere(
                                                (j) => j.nome == nome,
                                                orElse: () => Jogo(
                                                  id: -1,
                                                  nome: '',
                                                  imagem: '',
                                                  usuarioId: _usuarioId!,
                                                ),
                                              );

                                          if (jogoParaRemover.id != -1) {
                                            await jogoDAO.deletar(
                                              jogoParaRemover.id!,
                                            );
                                            setState(() {
                                              _favoritosIds.remove(nome);
                                            });

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Jogo removido dos favoritos',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } else {
                                          // Adicionar aos favoritos
                                          final novoJogo = Jogo(
                                            nome: game.nome,
                                            imagem: game.imagem,
                                            usuarioId: _usuarioId!,
                                          );

                                          await jogoDAO.inserir(novoJogo);
                                          setState(() {
                                            _favoritosIds.add(nome);
                                          });

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Jogo adicionado aos favoritos!',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      transitionBuilder: (child, animation) =>
                                          ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          ),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          _favoritosIds.contains(game.nome)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          key: ValueKey(
                                            _favoritosIds.contains(game.nome),
                                          ),
                                          color:
                                              _favoritosIds.contains(game.nome)
                                              ? Colors.red
                                              : Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // TÍTULO
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                              child: Text(
                                game.nome,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // GÊNEROS
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Text(
                                generosFormatados.isNotEmpty
                                    ? generosFormatados
                                    : 'Sem gênero',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // PAGINAÇÃO (SEPARADO)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_totalPages, (index) {
                        int pageNum = index + 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pageNum == _currentPage
                                  ? Colors.blue
                                  : Colors.grey[800],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            onPressed: () {
                              _fetchGames(pageNum);

                              _gameListScrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Text(
                              '$pageNum',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget SearchScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Pesquisar Jogos'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24.0),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Digite o nome do jogo',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: _searchGames,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator(color: Colors.blue)
                : _errorMessage.isNotEmpty
                ? Text(_errorMessage, style: const TextStyle(color: Colors.red))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final game = _searchResults[index];
                        String generosFormatados = game.generos.join(', ');

                        return Card(
                          color: const Color(0xFF1E1E1E),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: game.imagem.isNotEmpty
                                ? Image.network(
                                    game.imagem,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    size: 50.0,
                                    Icons.videogame_asset,
                                    color: Colors.grey,
                                  ),
                            title: Text(
                              game.nome,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              generosFormatados,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: GestureDetector(
                              onTap: () async {
                                final jogoDAO = JogoDAO();
                                final nome = game.nome;
                                final imagem = game.imagem;

                                final jaFavoritado = _favoritosIds.contains(
                                  nome,
                                );

                                if (jaFavoritado) {
                                  final jogosUsuario = await jogoDAO
                                      .listarPorUsuario(_usuarioId!);
                                  final jogoParaRemover = jogosUsuario
                                      .firstWhere(
                                        (j) => j.nome == nome,
                                        orElse: () => Jogo(
                                          id: -1,
                                          nome: '',
                                          imagem: '',
                                          usuarioId: _usuarioId!,
                                        ),
                                      );

                                  if (jogoParaRemover.id != -1) {
                                    await jogoDAO.deletar(jogoParaRemover.id!);
                                    setState(() {
                                      _favoritosIds.remove(nome);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Jogo removido dos favoritos',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else {
                                  final novoJogo = Jogo(
                                    nome: nome,
                                    imagem: imagem,
                                    usuarioId: _usuarioId!,
                                  );
                                  await jogoDAO.inserir(novoJogo);
                                  setState(() {
                                    _favoritosIds.add(nome);
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Jogo adicionado aos favoritos!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                child: Icon(
                                  _favoritosIds.contains(game.nome)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  key: ValueKey(
                                    _favoritosIds.contains(game.nome),
                                  ),
                                  color: _favoritosIds.contains(game.nome)
                                      ? Colors.red
                                      : Colors.white,
                                  size: 28.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritosScreen() {
    final jogoDAO = JogoDAO();

    if (_usuarioId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Meus Favoritos'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24.0),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Jogo>>(
        future: jogoDAO.listarPorUsuario(_usuarioId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum jogo favorito encontrado',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final jogos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: jogos.length,
              itemBuilder: (context, index) {
                final jogo = jogos[index];
                return Card(
                  color: const Color(0xFF1E1E1E),
                  child: ListTile(
                    leading: jogo.imagem.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              jogo.imagem,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.videogame_asset, color: Colors.grey),
                    title: Text(
                      jogo.nome,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await jogoDAO.deletar(jogo.id!);
                        setState(() {}); // Atualiza a tela após remover
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildPerfilScreen() {
    final jogoDAO = JogoDAO();

    return FutureBuilder<List<Jogo>>(
      future: _usuarioId != null ? jogoDAO.listarPorUsuario(_usuarioId!) : null,
      builder: (context, snapshot) {
        int totalFavoritos = 0;

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          totalFavoritos = snapshot.data!.length;
        }

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text('Meu Perfil'),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  _nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _email,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 24),

                // Contador de favoritos
                if (snapshot.connectionState == ConnectionState.waiting)
                  const CircularProgressIndicator(color: Colors.blue)
                else
                  Text(
                    '$totalFavoritos',
                    style: const TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                Text(
                  '${totalFavoritos == 1 ? "Jogo" : "Jogos"} Favoritos',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    logout();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logout realizado")),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Desenvolvido por Rodrigo Noelli Duarte © 2025',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () async {
                    final url = Uri.parse('https://github.com/shinzola');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Não foi possível abrir o link do GitHub',
                          ),
                        ),
                      );
                    }
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.github,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

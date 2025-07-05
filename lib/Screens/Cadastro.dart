import 'package:flutter/material.dart';
import 'package:myfavgame/Classes/Usuario.dart';
import 'package:myfavgame/DAO/Usuario_Dao.dart';
import 'package:myfavgame/Screens/HomeScreen.dart';
import 'package:path/path.dart';
import 'Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  Future<void> salvarSessao(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usuario_id', usuario.id!);
    await prefs.setString('usuario_nome', usuario.nome);
    await prefs.setString('usuario_email', usuario.email);
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  UsuarioDAO _usuarioDAO = UsuarioDAO();

  bool _senhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone arredondado
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person_add, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 24),

              const Text(
                'Criar Conta',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Preencha os dados abaixo',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Campo Nome
              TextField(
                controller: _nomeController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Nome', Icons.person),
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Email', Icons.email),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Campo Senha
              TextField(
                controller: _senhaController,
                obscureText: !_senhaVisivel,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecorationSenha('Senha'),
              ),
              const SizedBox(height: 24),

              // Botão Criar Conta
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String nome = _nomeController.text.trim();
                    String email = _emailController.text.trim();
                    String senha = _senhaController.text;

                    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preencha todos os campos'),
                        ),
                      );
                      return;
                    }

                    Usuario novoUsuario = Usuario(
                      nome: nome,
                      email: email,
                      senha: senha,
                    );

                    try {
                      int resultado = await _usuarioDAO.inserir(novoUsuario);
                      novoUsuario.id = resultado; // ✅ Aqui está a correção

                      if (resultado > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Conta criada com sucesso!'),
                          ),
                        );
                        await salvarSessao(novoUsuario);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao criar conta')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Criar Conta',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Botão para Login
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Text(
                  'Já tem uma conta? Fazer login',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input decoration padrão
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  // Input decoration para senha com botão visível/ocultar
  InputDecoration _inputDecorationSenha(String label) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
      suffixIcon: IconButton(
        icon: Icon(
          _senhaVisivel ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _senhaVisivel = !_senhaVisivel;
          });
        },
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }
}

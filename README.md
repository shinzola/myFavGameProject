
# 🎮 MyFavGame

MyFavGame é um aplicativo Flutter onde os usuários podem buscar, favoritar e visualizar jogos utilizando a API RAWG. O app também permite cadastro/login com persistência de sessão local, integrando banco de dados SQLite para armazenar os jogos favoritos do usuário.

---

## 📱 Funcionalidades

- 🔍 **Pesquisar Jogos**: busca por nome diretamente na API RAWG.
- ❤️ **Favoritar Jogos**: armazena os jogos localmente com SQLite por usuário logado.
- 👤 **Cadastro e Login**: sistema de autenticação simples com persistência via `SharedPreferences`.
- 🧠 **Sessão Persistente**: mantém o usuário logado mesmo após fechar o app.
- 🧾 **Perfil do Usuário**: exibe nome, email e total de jogos favoritados.
- 💡 **Remover Favoritos**: gerencia sua lista de favoritos com apenas um clique.
- 🌙 **Tema Escuro**: interface amigável com estilo moderno e escuro.

---

## 🛠️ Tecnologias Usadas

| Tecnologia             | Função                                      |
|------------------------|---------------------------------------------|
| Flutter                | Framework para desenvolvimento do app       |
| Dart                   | Linguagem de programação do app             |
| SQLite (sqflite)       | Banco de dados local                        |
| RAWG API               | API pública para informações de jogos       |
| SharedPreferences      | Armazenamento de sessão (usuário logado)    |
| Path Provider          | Acesso a diretórios locais                  |
| URL Launcher           | Abertura de links externos (GitHub, etc)    |

---

## 📁 Estrutura de Pastas

```
lib/
├── Classes/          # Modelos (Usuario, Jogo, etc)
├── DAO/              # Classes DAO (JogoDAO, UsuarioDAO)
├── Database/         # Classe de conexão com SQLite
├── Screens/          # Telas do app (Login, Cadastro, Home, etc)
├── API/              # Função de conexão e consumo da API
└── main.dart         # Entrada do app
```

---

## ⚙️ Como Executar o Projeto

### ✅ Pré-requisitos

- [Flutter](https://flutter.dev/docs/get-started/install) instalado
- Android Studio ou VSCode com extensões Flutter/Dart
- Emulador Android ou dispositivo físico

---

### 📦 Instalação

```bash
git clone https://github.com/shinzola/myfavgame.git
cd myfavgame
flutter pub get
```

---

### ▶️ Executar

```bash
flutter run
```

Ou, para gerar um APK:

```bash
flutter build apk
```

O APK será gerado em:
```
build/app/outputs/flutter-apk/app-release.apk
```

## 🌐 Sobre a RAWG API

Este app utiliza a [RAWG Video Games Database API](https://rawg.io/apidocs). Para usar, registre-se e obtenha sua `API_KEY`. Insira essa chave no endpoint de busca, por exemplo:

```dart
  final String _apiKey = 'sua_API;
```

---

## 🙋‍♂️ Autor

Desenvolvido por **Rodrigo “Shin” Duarte**  
[![GitHub](https://img.shields.io/badge/GitHub-shinzola-181717?style=for-the-badge&logo=github)](https://github.com/shinzola)


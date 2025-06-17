# 🎮 MyFavGame

Aplicativo Flutter para gerenciar sua lista de jogos favoritos, com banco de dados local (**SQLite**) e consumo de dados externos via API.

![Flutter](https://img.shields.io/badge/Flutter-Framework-blue?logo=flutter)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-Em%20Desenvolvimento-yellow)

---

## 📱 Funcionalidades

- 🔐 Sistema de login e cadastro de usuários.
- 🎯 CRUD completo de:
  - Jogos 🎮
  - Gêneros 🎧
  - Plataformas 🖥️
  - Status ✅
- 🔗 Consumo de API externa ([RAWG](https://rawg.io/apidocs)) para buscar dados dos jogos.
- 💾 Armazenamento local com **SQLite**.
- 🌐 Funcionalidade híbrida: dados locais + dados online.
- 🔍 Filtros por plataforma, gênero e status.

---

## 🚀 Tecnologias utilizadas

- ✔️ Flutter
- ✔️ SQFlite (SQLite)
- ✔️ HTTP (API)
- ✔️ Path Provider
- ✔️ Dart

---

## 🔧 Instalação e execução

### Pré-requisitos

- ✅ Flutter instalado ([Guia oficial](https://docs.flutter.dev/get-started/install))
- ✅ Emulador Android, dispositivo físico ou simulador iOS
- ✅ Chave da API [RAWG](https://rawg.io/apidocs) *(opcional para funcionalidades online)*

### Executando o projeto

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/MyFavGame.git

# Acesse o diretório
cd MyFavGame

# Instale as dependências
flutter pub get

# Execute o app
flutter run

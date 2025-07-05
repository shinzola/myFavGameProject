import 'package:flutter/material.dart';
import 'package:myfavgame/Screens/HomeScreen.dart';
import 'package:myfavgame/Screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final usuario_id = prefs.getInt('usuario_id');

  runApp(
    MaterialApp(
      home: usuario_id != null ? const HomeScreen() : const Login(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

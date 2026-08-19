import 'package:flutter/material.dart';

import 'ui/splash.dart';

void main() {
  runApp(const AguaApp());
}

class AguaApp extends StatefulWidget {
  const AguaApp({super.key});

  @override
  State<AguaApp> createState() => _AguaAppState();
}

class _AguaAppState extends State<AguaApp> {
  bool temaEscuro = false;

  void alternarTema(bool valor) {
    setState(() => temaEscuro = valor);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumo de Água',
      themeMode: temaEscuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(onTemaChange: alternarTema),
    );
  }
}

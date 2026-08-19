import 'package:flutter/material.dart';

import 'home.dart';

class SplashScreen extends StatelessWidget {
  final Function(bool) onTemaChange;

  const SplashScreen({super.key, required this.onTemaChange});

  @override
  Widget build(BuildContext context) {
    bool temaEscuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.water_drop, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Consumo de Água',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Tema escuro'),
                Switch(value: temaEscuro, onChanged: onTemaChange),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

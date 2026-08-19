import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modal_agua.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> registros = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString('registros_agua');

    List<Map<String, dynamic>> carregados = [];

    if (dados != null) {
      try {
        final decodificado = json.decode(dados) as List<dynamic>;

        carregados = decodificado
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      } catch (_) {
        carregados = [];
      }
    }

    if (!mounted) return;

    setState(() {
      registros = carregados;
      _carregando = false;
    });
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('registros_agua', json.encode(registros));
  }

  void _adicionarRegistro(Map<String, dynamic> novo) {
    setState(() {
      registros.add(novo);
    });

    _salvarDados();
  }

  Future<void> _confirmarExclusao(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir registro'),
        content: const Text('Tem certeza que deseja excluir este registro?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      _excluirRegistro(index);
    }
  }

  void _excluirRegistro(int index) {
    setState(() {
      registros.removeAt(index);
    });

    _salvarDados();
  }

  double _paraDouble(dynamic valor) {
    if (valor is num) {
      return valor.toDouble();
    }

    return double.tryParse(valor.toString().replaceAll(',', '.')) ?? 0;
  }

  double _metaDiaria(double peso) {
    return peso * 35;
  }

  double _totalHoje() {
    final hoje = DateTime.now();

    double total = 0;

    for (final registro in registros) {
      final data = registro['data'].toString();

      if (data ==
          '${hoje.year.toString().padLeft(4, '0')}-'
              '${hoje.month.toString().padLeft(2, '0')}-'
              '${hoje.day.toString().padLeft(2, '0')}') {
        total += _paraDouble(registro['quantidade_em_ml']);
      }
    }

    return total;
  }

  double _pesoAtual() {
    if (registros.isEmpty) {
      return 0;
    }

    return _paraDouble(registros.last['peso_atual_kg']);
  }

  double _porcentagemMeta() {
    final peso = _pesoAtual();

    if (peso <= 0) {
      return 0;
    }

    final meta = _metaDiaria(peso);
    final total = _totalHoje();

    return (total / meta) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final peso = _pesoAtual();
    final total = _totalHoje();
    final meta = _metaDiaria(peso);
    final porcentagem = _porcentagemMeta();

    return Scaffold(
      appBar: AppBar(title: const Text('Consumo de Água')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: Colors.blue,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total consumido hoje',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${total.toStringAsFixed(0)} ml',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Meta: ${meta.toStringAsFixed(0)} ml'),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: (porcentagem / 100).clamp(0.0, 1.0),
                          ),
                          const SizedBox(height: 8),
                          Text('${porcentagem.toStringAsFixed(1)}% da meta'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: registros.isEmpty
                      ? const Center(child: Text('Nenhum consumo registrado'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: registros.length,
                          itemBuilder: (context, index) {
                            final registro = registros[index];

                            final quantidade = _paraDouble(
                              registro['quantidade_em_ml'],
                            );

                            final peso = _paraDouble(registro['peso_atual_kg']);

                            return Card(
                              color: isDark
                                  ? const Color(0xFF1E1E1E)
                                  : Colors.white,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.water_drop,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  '${quantidade.toStringAsFixed(0)} ml',
                                ),
                                subtitle: Text(
                                  'Data: ${registro['data']}\n'
                                  'Peso: ${peso.toStringAsFixed(1)} kg',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _confirmarExclusao(index),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ModalAgua(
                                      registro: registro,
                                      index: index,
                                      onSalvar: (atualizado) {
                                        setState(() {
                                          registros[index] = atualizado;
                                        });

                                        _salvarDados();
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => ModalAgua(onSalvar: _adicionarRegistro),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

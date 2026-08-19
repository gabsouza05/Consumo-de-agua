import 'package:flutter/material.dart';

class ModalAgua extends StatefulWidget {
  final Map<String, dynamic>? registro;
  final int? index;
  final Function(Map<String, dynamic>) onSalvar;

  const ModalAgua({
    super.key,
    this.registro,
    this.index,
    required this.onSalvar,
  });

  @override
  State<ModalAgua> createState() => _ModalAguaState();
}

class _ModalAguaState extends State<ModalAgua> {
  final _formKey = GlobalKey<FormState>();

  final _dataController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _pesoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.registro != null) {
      _dataController.text = widget.registro!['data'].toString();

      _quantidadeController.text = widget.registro!['quantidade_em_ml']
          .toString();

      _pesoController.text = widget.registro!['peso_atual_kg'].toString();
    }
  }

  @override
  void dispose() {
    _dataController.dispose();
    _quantidadeController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  double? _parseNumero(String texto) {
    return double.tryParse(texto.trim().replaceAll(',', '.'));
  }

  String? _validarTexto(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }

    return null;
  }

  String? _validarNumero(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }

    final numero = _parseNumero(valor);

    if (numero == null) {
      return 'Digite um número válido';
    }

    if (numero <= 0) {
      return 'Deve ser maior que zero';
    }

    return null;
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onSalvar({
      'data': _dataController.text.trim(),
      'quantidade_em_ml': _parseNumero(_quantidadeController.text)!,
      'peso_atual_kg': _parseNumero(_pesoController.text)!,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.registro != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                editando ? 'Editar consumo' : 'Novo consumo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _campo(
                'Data',
                _dataController,
                tipo: TextInputType.datetime,
                validator: _validarTexto,
              ),
              const SizedBox(height: 12),
              _campo(
                'Quantidade (ml)',
                _quantidadeController,
                tipo: const TextInputType.numberWithOptions(decimal: true),
                validator: _validarNumero,
              ),
              const SizedBox(height: 12),
              _campo(
                'Peso atual (kg)',
                _pesoController,
                tipo: const TextInputType.numberWithOptions(decimal: true),
                validator: _validarNumero,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(
    String label,
    TextEditingController controller, {
    TextInputType tipo = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipo,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

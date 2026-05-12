import 'package:flutter/material.dart';
import '../../services/cliente_service.dart';

class CrearclientePage extends StatefulWidget {
  const CrearclientePage({super.key});

  @override
  State<CrearclientePage> createState() => _CrearclientePageState();
}

class _CrearclientePageState extends State<CrearclientePage> {
  final nombreCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

  void guardar() async {
    await ClienteService.crearCliente(
      nombreCtrl.text,
      telefonoCtrl.text
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear cliente")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: telefonoCtrl, decoration: const InputDecoration(labelText: "telefono")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: guardar, child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }
}
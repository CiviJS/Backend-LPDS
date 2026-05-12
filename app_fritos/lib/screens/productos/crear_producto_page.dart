import 'package:flutter/material.dart';
import '../../services/producto_service.dart';

class CrearProductoPage extends StatefulWidget {
  const CrearProductoPage({super.key});

  @override
  State<CrearProductoPage> createState() => _CrearProductoPageState();
}

class _CrearProductoPageState extends State<CrearProductoPage> {
  final nombreCtrl = TextEditingController();
  final precioCtrl = TextEditingController();

  void guardar() async {
    await ProductoService.crearProducto(
      nombreCtrl.text,
      double.parse(precioCtrl.text),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear producto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: precioCtrl, decoration: const InputDecoration(labelText: "Precio")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: guardar, child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }
}
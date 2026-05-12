import 'package:flutter/material.dart';
import '../../models/cliente.dart';
import '../../services/Cliente_service.dart';

class EditarClientePage extends StatefulWidget {
  final Cliente cliente;

  const EditarClientePage({super.key, required this.cliente});

  @override
  State<EditarClientePage> createState() => _EditarClientePageState();
}

class _EditarClientePageState extends State<EditarClientePage> {
  late TextEditingController nombreCtrl;
  late TextEditingController telefonoCtrl;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.cliente.nombre);
    telefonoCtrl = TextEditingController(text: widget.cliente.telefono);
  }

  void actualizar() async {
    final actualizado = Cliente(
      id: widget.cliente.id,
      nombre: nombreCtrl.text,
       telefono: telefonoCtrl.text,
     
    );

    await ClienteService.actualizarCliente(actualizado);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nombreCtrl),
            TextField(controller: telefonoCtrl),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: actualizar, child: const Text("Actualizar"))
          ],
        ),
      ),
    );
  }
}
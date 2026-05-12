import 'package:flutter/material.dart';
import '../../models/producto.dart';
import '../../services/producto_service.dart';

class EditarProductoPage extends StatefulWidget {
  final Producto producto;

  const EditarProductoPage({super.key, required this.producto});

  @override
  State<EditarProductoPage> createState() => _EditarProductoPageState();
}

class _EditarProductoPageState extends State<EditarProductoPage> {
  late TextEditingController nombreCtrl;
  late TextEditingController precioCtrl;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.producto.nombre);
    precioCtrl = TextEditingController(text: widget.producto.precio.toString());
  }

  

  void actualizar() async {
    if(nombreCtrl.text.isEmpty || precioCtrl.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("campos obligatorios")));
    }
    final actualizado = Producto(
      id: widget.producto.id,
      nombre: nombreCtrl.text,
      precio: double.parse(precioCtrl.text),
      activo: 1,
    );

    await ProductoService.actualizarProducto(actualizado);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar producto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nombreCtrl),
            TextField(controller: precioCtrl),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: actualizar, child: const Text("Actualizar"))
          ],
        ),
      ),
    );
  }
}
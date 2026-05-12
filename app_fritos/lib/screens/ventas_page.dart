import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class VentasPage extends StatefulWidget {
  const VentasPage({super.key});
  @override
  State<VentasPage> createState() => _VentasPage();
}

class _VentasPage extends State<VentasPage> {
  List<Producto> productos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    final data = await ProductoService.getProductos();
    setState(() {
      productos = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Productos")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (_, i) {
                final p = productos[i];
                return ListTile(
                  title: Text(p.nombre),
                  subtitle: Text("\$${p.precio}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {},
                        child: Container(
                          margin: const EdgeInsets.only(right: 100),
                          
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.restore_from_trash_outlined),
                              SizedBox(
                                height: 4,
                              ), // Espacio entre ícono y texto
                              Text("Eliminar Venta"),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {},
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add),
                              SizedBox(
                                height: 4,
                              ), // Espacio entre ícono y texto
                              Text("Añadir Venta"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

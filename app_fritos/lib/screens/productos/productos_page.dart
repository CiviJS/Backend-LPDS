import 'package:flutter/material.dart';
import '../../models/producto.dart';
import '../../services/producto_service.dart';
import 'crear_producto_page.dart';
import 'editar_producto_page.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
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

  Future<void> eliminar(int id) async {
    await ProductoService.eliminarProducto(id);
    cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Productos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearProductoPage()),
          );
          cargar();
        },
        child: const Icon(Icons.add),
      ),
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
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarProductoPage(producto: p),
                            ),
                          );
                          cargar();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => eliminar(p.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
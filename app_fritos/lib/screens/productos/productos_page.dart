import 'package:flutter/material.dart';
import '../../models/producto.dart';
import '../../services/ProductoService.dart';
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
    if (!mounted) return; // Guardián de contexto asíncrono
    setState(() {
      productos = data;
      loading = false;
    });
  }

  Future<void> eliminar(int id) async {
    try {
      await ProductoService.eliminarProducto(id);
      if (!mounted) return;
      // Refrescar lista y confirmar al usuario
      await cargar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Deseas eliminar este producto?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (ok == true) {
      await eliminar(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearProductoPage()),
          );
          if (!mounted) return;
          cargar();
        },
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                // Adaptabilidad de columnas según el ancho del dispositivo
                int columnas = 4;
                double alturaTarjeta = 140.0;

                if (constraints.maxWidth < 600) {
                  columnas = 2; // Celulares
                  alturaTarjeta = 145.0;
                } else if (constraints.maxWidth < 900) {
                  columnas = 3; // Tablets
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnas,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    mainAxisExtent: alturaTarjeta,
                  ),
                  itemCount: productos.length,
                  itemBuilder: (context, i) {
                    final p = productos[i];
                    return _ItemProductoCard(
                      producto: p,
                      onEditar: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarProductoPage(producto: p),
                          ),
                        );
                        if (!mounted) return;
                          cargar();
                      },
                        onEliminar: () => _confirmDelete(context, p.id),
                    );
                  },
                );
              },
            ),
    );
  }
}

// COMPONENTE: Tarjeta del Producto para catálogo adaptativo
class _ItemProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _ItemProductoCard({
    required this.producto,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Theme.of(context).dividerColor.withAlpha(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila Superior: Nombre del producto y botones de acción rápida
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    producto.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Contenedor compacto para acciones de administración
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18.0),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 16.0,
                      onPressed: onEditar,
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18.0),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 16.0,
                      onPressed: onEliminar,
                    ),
                  ],
                ),
              ],
            ),
            
            // Empuja el precio al fondo para que todas las tarjetas se mantengan alineadas
            const Spacer(),
            
            // Sección de Precio
            Text(
              "\$${producto.precio}",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Text("Stock: ${producto.cantidadActual}"),
            Text("Stock inicial: ${producto.cantidadInicial}"),
          ],
        ),
      ),
    );
  }
}
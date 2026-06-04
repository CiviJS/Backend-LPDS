import 'package:flutter/material.dart';
import '../../models/venta.dart';
import '../../models/ventaReporte.dart';
import '../../services/VentasService.dart';

class VentasPage extends StatefulWidget {
  const VentasPage({super.key});

  @override
  State<VentasPage> createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  List<VentaReporte> productos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    final data = await VentasService.obtenerVentas();
    if (!mounted) return;
    setState(() {
      productos = data;
      loading = false;
    });
  }

  Future<void> registrarVenta(Venta venta, String nombreProducto) async {
    await VentasService.registrarVentas(context, [venta]);
    if (!mounted) return;
  
    cargar();
  }

  Future<void> desHacerVenta(int id, int totalVendido) async {
    if (totalVendido < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay ventas para deshacer")),
      );
      return;
    }
    await VentasService.desHacerVentaByProducto(context, id);
    if (!mounted) return;
    cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                // Evaluamos el ancho de la pantalla actual
                int columnas = 4;
                double alturaTarjeta = 185.0;

                if (constraints.maxWidth < 600) {
                  columnas = 2; // En celulares pinta 2 columnas
                  alturaTarjeta = 195.0; // Un toque más de altura por espacio de texto
                } else if (constraints.maxWidth < 900) {
                  columnas = 3; // En tablets medianas pinta 3 columnas
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
                      onVender: () => registrarVenta(
                        Venta(
                          productoId: p.id,
                          cantidad: 1, // esto lo pongo asi por si en un futuro queremos vender mas de una unidad a la vez o manejamos por colas
                          precioUnitario: p.precioSugerido,
                        ),
                        p.nombre,
                      ),
                      onDeshacer: () => desHacerVenta(p.id, p.totalVendidoHoy),
                    );
                  },
                );
              },
            ),
    );
  }
}

// COMPONENTE: Tarjeta optimizada y limpia
class _ItemProductoCard extends StatelessWidget {
  final VentaReporte producto;
  final VoidCallback onVender;
  final VoidCallback onDeshacer;

  const _ItemProductoCard({
    required this.producto,
    required this.onVender,
    required this.onDeshacer,
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
            Text(
              producto.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              "\$${producto.precioSugerido}",
              style: TextStyle(
                fontSize: 13.0,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              'Ventas hoy: ${producto.totalVendidoHoy}',
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const Spacer(),
            Divider(height: 1, color: Theme.of(context).dividerColor.withAlpha(30)),
            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BotonAccion(
                  icon: Icons.restore_from_trash_outlined,
                  label: "Deshacer",
                  onTap: onDeshacer,
                ),
                _BotonAccion(
                  icon: Icons.add,
                  label: "Vender",
                  onTap: onVender,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// COMPONENTE: Botón de acción adaptativo
class _BotonAccion extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BotonAccion({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22.0),
            const SizedBox(height: 2.0),
            Text(
              label,
              style: const TextStyle(fontSize: 11.0),
            ),
          ],
        ),
      ),
    );
  }
}
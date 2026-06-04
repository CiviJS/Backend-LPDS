import 'package:flutter/material.dart';
import '../../models/ventaReporte.dart';
import '../../services/ReportesService.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  bool loading = true;
  List<VentaReporte> ventas = [];
  String? error;

  @override
  void initState() {
    super.initState();
    cargarReportes();
  }

  Future<void> cargarReportes() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final data = await ReportesService.obtenerVentasParaReportes();
      if (!mounted) return;
      setState(() {
        ventas = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'No se pudo cargar los datos de reportes. Verifique la conexion.';
        loading = false;
      });
    }
  }

  int get totalVentasHoy => ventas.fold(0, (value, item) => value + item.totalVendidoHoy);

  double get totalIngresoEstimadoHoy => ventas.fold(
        0.0,
        (value, item) => value + item.precioSugerido * item.totalVendidoHoy,
      );

  int get productosActivos => ventas.where((item) => item.activo == 1).length;

  int get productosConVentasHoy => ventas.where((item) => item.totalVendidoHoy > 0).length;

  List<VentaReporte> get topVendidos {
    final lista = ventas.where((item) => item.totalVendidoHoy > 0).toList();
    lista.sort((a, b) => b.totalVendidoHoy.compareTo(a.totalVendidoHoy));
    return lista;
  }

  List<VentaReporte> get topPorIngreso {
    final lista = ventas.where((item) => item.totalVendidoHoy > 0).toList();
    lista.sort((a, b) =>
        (b.precioSugerido * b.totalVendidoHoy).compareTo(a.precioSugerido * a.totalVendidoHoy));
    return lista;
  }

  List<VentaReporte> get productosMasRapido {
    return topVendidos.take(5).toList();
  }

  List<VentaReporte> get recomendacionesBase {
    return ventas
        .where((item) => item.totalVendidoHoy >= 3)
        .toList()
      ..sort((a, b) => b.totalVendidoHoy.compareTo(a.totalVendidoHoy));
  }

  List<String> get recomendaciones {
    if (ventas.isEmpty) {
      return ['No hay datos suficientes para generar recomendaciones.'];
    }

    final suggestions = <String>[];

    if (recomendacionesBase.isNotEmpty) {
      suggestions.add(
        'Reponer los siguientes productos rapidamente: ${recomendacionesBase.take(3).map((item) => item.nombre).join(', ')}.',
      );
      suggestions.add(
        'Ofrecer promocion a los productos con mayor rotacion: ${productosMasRapido.take(2).map((item) => item.nombre).join(' y ')}.',
      );
    } else {
      suggestions.add('No hay productos de alta rotacion hoy. Revisa los menus y ofertas.');
    }

    suggestions.add(
      'Revisa la disponibilidad de los productos con ventas continuas para evitar quiebres de stock.',
    );

    return suggestions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(error!, textAlign: TextAlign.center),
                        const SizedBox(height: 12.0),
                        ElevatedButton(
                          onPressed: cargarReportes,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: cargarReportes,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Text(
                        'Reportes de ventas',
                        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12.0),
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: [
                          _SummaryCard(
                            title: 'Ventas hoy',
                            value: totalVentasHoy.toString(),
                            icon: Icons.show_chart,
                            color: Colors.blue,
                          ),
                          _SummaryCard(
                            title: 'Productos activos',
                            value: productosActivos.toString(),
                            icon: Icons.layers,
                            color: Colors.teal,
                          ),
                          _SummaryCard(
                            title: 'Productos vendidos',
                            value: productosConVentasHoy.toString(),
                            icon: Icons.shopping_cart,
                            color: Colors.orange,
                          ),
                          _SummaryCard(
                            title: 'Ingreso estimado',
                            value: '\$${totalIngresoEstimadoHoy.toStringAsFixed(2)}',
                            icon: Icons.monetization_on,
                            color: Colors.green,
                          ),
                          _SummaryCard(
                            title: 'Productos alta rotacion',
                            value: recomendacionesBase.length.toString(),
                            icon: Icons.bolt,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18.0),
                      _SectionTitle(title: 'Top productos mas vendidos'),
                      ..._buildTopProducts(),
                      const SizedBox(height: 18.0),
                      _SectionTitle(title: 'Productos que se agotan rápido'),
                      ..._buildFastMovingProducts(),
                      const SizedBox(height: 18.0),
                      _SectionTitle(title: 'Productos con mayor ingreso estimado'),
                      ..._buildTopRevenueProducts(),
                      const SizedBox(height: 18.0),
                      _SectionTitle(title: 'Recomendaciones'),
                      ..._buildRecomendaciones(),
                      const SizedBox(height: 18.0),
                      _SectionTitle(title: 'Alerta de rotacion / Stock potencial'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Estos productos muestran ventas constantes hoy y deben revisarse para evitar quiebres de inventario.',
                        ),
                      ),
                      ..._buildStockAlerts(),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
    );
  }

  List<Widget> _buildTopProducts() {
    if (topVendidos.isEmpty) {
      return [const Text('No hay ventas registradas hoy.')];
    }

    return topVendidos.take(5).map((item) {
      return _ReportItemCard(
        title: item.nombre,
        subtitle: 'Vendidos hoy: ${item.totalVendidoHoy}',
        detail: 'Precio: ${item.precioSugerido.toStringAsFixed(2)}',
      );
    }).toList();
  }

  List<Widget> _buildFastMovingProducts() {
    final list = productosMasRapido;
    if (list.isEmpty) {
      return [const Text('No hay productos con suficiente rotacion hoy.')];
    }

    return list.map((item) {
      return _ReportItemCard(
        title: item.nombre,
        subtitle: 'Ritmo alto: ${item.totalVendidoHoy} ventas hoy',
        detail: 'Sugerencia: revisar stock o preparar reposicion',
      );
    }).toList();
  }

  List<Widget> _buildTopRevenueProducts() {
    final list = topPorIngreso;
    if (list.isEmpty) {
      return [const Text('No hay productos con ventas para calcular ingresos.')];
    }

    return list.take(4).map((item) {
      final ingreso = item.precioSugerido * item.totalVendidoHoy;
      return _ReportItemCard(
        title: item.nombre,
        subtitle: 'Ingreso estimado: \$${ingreso.toStringAsFixed(2)}',
        detail: 'Vendidos hoy: ${item.totalVendidoHoy}',
      );
    }).toList();
  }

  List<Widget> _buildRecomendaciones() {
    return recomendaciones.map((text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 18.0)),
            Expanded(child: Text(text)),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildStockAlerts() {
    final fastProducts = recomendacionesBase;
    if (fastProducts.isEmpty) {
      return [const Text('Aun no hay productos con ritmo de venta alto.')];
    }

    return fastProducts.take(4).map((item) {
      return _ReportItemCard(
        title: item.nombre,
        subtitle: 'Ventas hoy: ${item.totalVendidoHoy}',
        detail: 'Recomendacion: revisar inventario/manualmente.',
      );
    }).toList();
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156.0,
      child: Card(
        color: color.withValues(alpha: 0.08),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 22.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(color: color, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                value,
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ReportItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String detail;

  const _ReportItemCard({
    required this.title,
    required this.subtitle,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6.0),
            Text(subtitle),
            const SizedBox(height: 6.0),
            Text(detail, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13.0)),
          ],
        ),
      ),
    );
  }
}

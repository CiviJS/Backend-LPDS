import 'package:flutter/material.dart';
import '../../models/cliente.dart';
import '../../models/deuda.dart';
import '../../models/producto.dart';
import '../../services/ClienteService.dart';
import '../../services/DeudasService.dart';
import '../../services/ProductoService.dart';

class DeudasPage extends StatefulWidget {
  const DeudasPage({super.key});

  @override
  State<DeudasPage> createState() => _DeudasPageState();
}

class _DeudasPageState extends State<DeudasPage> {
  final TextEditingController _searchController = TextEditingController();
  bool loading = true;
  String? error;
  List<Deuda> deudas = [];

  @override
  void initState() {
    super.initState();
    cargarDeudas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> cargarDeudas() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final data = await DeudasService.obtenerDeudas();
      if (!mounted) return;
      setState(() {
        deudas = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'No se pudo cargar las deudas. Verifique la conexión.';
        loading = false;
      });
    }
  }

  Future<void> eliminarDeudaCliente(Deuda deuda) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar deuda'),
          content: const Text('¿Deseas eliminar esta deuda para este cliente?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await DeudasService.eliminarDeudaPorCliente(deuda.clienteId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deuda eliminada correctamente')),
      );
      cargarDeudas();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar deuda: ${e.toString()}')),
      );
    }
  }

  List<Deuda> get _deudasFiltradas {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return deudas;
    return deudas.where((deuda) {
      return deuda.nombre.toLowerCase().contains(query) || deuda.telefono.toLowerCase().contains(query);
    }).toList();
  }

  double get _totalDeuda => deudas.fold(0.0, (value, item) => value + item.totalDeuda);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const CrearDeudaPage()),
          );
          if (created == true) {
            cargarDeudas();
          }
        },
        child: const Icon(Icons.add),
      ),
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
                          onPressed: cargarDeudas,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: cargarDeudas,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Text(
                        'Módulo de Deudas',
                        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Buscar cliente o teléfono',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16.0),
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: [
                          _InfoCard(
                            title: 'Clientes con deuda',
                            value: deudas.length.toString(),
                            color: Colors.blue,
                          ),
                          _InfoCard(
                            title: 'Total adeudado',
                            value: '\$${_totalDeuda.toStringAsFixed(2)}',
                            color: Colors.redAccent,
                          ),
                          _InfoCard(
                            title: 'Promedio por cliente',
                            value: deudas.isEmpty ? '0.00' : '\$${(_totalDeuda / deudas.length).toStringAsFixed(2)}',
                            color: Colors.teal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18.0),
                      _SectionTitle(title: 'Deudas activas'),
                      if (_deudasFiltradas.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('No hay resultados para esta búsqueda.'),
                        )
                      else
                        ..._deudasFiltradas.map((deuda) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            elevation: 1,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              title: Text(deuda.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(deuda.telefono),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('\$${deuda.totalDeuda.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4.0),
                                      const Text('Total', style: TextStyle(fontSize: 12.0)),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    tooltip: 'Eliminar deuda',
                                    onPressed: () => eliminarDeudaCliente(deuda),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final updated = await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => DeudaDetallePage(deuda: deuda),
                                  ),
                                );
                                if (updated == true) {
                                  cargarDeudas();
                                }
                              },
                            ),
                          );
                        }),
                    ],
                  ),
                ),
    );
  }
}

class CrearDeudaPage extends StatefulWidget {
  const CrearDeudaPage({super.key});

  @override
  State<CrearDeudaPage> createState() => _CrearDeudaPageState();
}

class _CrearDeudaPageState extends State<CrearDeudaPage> {
  bool loading = true;
  bool saving = false;
  String? error;
  List<Cliente> clientes = [];
  List<Producto> productos = [];
  Cliente? clienteSeleccionado;
  final Map<int, int> cantidades = {};

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final clientesData = await ClienteService.getClientes();
      final productosData = await ProductoService.getProductos();
      if (!mounted) return;
      setState(() {
        clientes = clientesData;
        productos = productosData.where((p) => p.activo == 1).toList();
        if (clientes.isNotEmpty) {
          clienteSeleccionado = clientes.first;
        }
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'No se pudieron cargar clientes o productos.';
        loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get productosSeleccionados {
    return productos.where((producto) {
      final cantidad = cantidades[producto.id] ?? 0;
      return cantidad > 0;
    }).map((producto) {
      return {
        'id': producto.id,
        'cantidad': cantidades[producto.id] ?? 0,
      };
    }).toList();
  }

  double get totalEstimado {
    return productosSeleccionados.fold(0.0, (total, item) {
      final producto = productos.firstWhere((p) => p.id == item['id']);
      return total + producto.precio * (item['cantidad'] as int);
    });
  }

  Future<void> guardarDeuda() async {
    if (clienteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un cliente.')),
      );
      return;
    }

    final listaProductos = productosSeleccionados;
    if (listaProductos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un producto con cantidad mayor a 0.')),
      );
      return;
    }

    setState(() {
      saving = true;
    });

    try {
      await DeudasService.crearDeuda(clienteSeleccionado!.id, listaProductos);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar deuda: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar deuda')),
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
                        ElevatedButton(onPressed: cargarDatos, child: const Text('Reintentar')),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<Cliente>(
                        initialValue: clienteSeleccionado,
                        decoration: const InputDecoration(
                          labelText: 'Cliente',
                          border: OutlineInputBorder(),
                        ),
                        items: clientes.map((cliente) {
                          return DropdownMenuItem(
                            value: cliente,
                            child: Text('${cliente.nombre} - ${cliente.telefono}'),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() {
                          clienteSeleccionado = value;
                        }),
                      ),
                      const SizedBox(height: 16.0),
                      const Text('Productos', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: productos.length,
                          itemBuilder: (_, index) {
                            final producto = productos[index];
                            final cantidad = cantidades[producto.id] ?? 0;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4.0),
                                          Text('Precio: \$${producto.precio.toStringAsFixed(2)}'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              setState(() {
                                                final nueva = (cantidades[producto.id] ?? 0) - 1;
                                                cantidades[producto.id] = nueva < 0 ? 0 : nueva;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            width: 32.0,
                                            child: Text(
                                              cantidad.toString(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              setState(() {
                                                cantidades[producto.id] = (cantidades[producto.id] ?? 0) + 1;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text('Total estimado: \$${totalEstimado.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14.0),
                      ElevatedButton(
                        onPressed: saving ? null : guardarDeuda,
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48.0)),
                        child: saving ? const CircularProgressIndicator() : const Text('Registrar deuda'),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class DeudaDetallePage extends StatefulWidget {
  final Deuda deuda;

  const DeudaDetallePage({required this.deuda, super.key});

  @override
  State<DeudaDetallePage> createState() => _DeudaDetallePageState();
}

class _DeudaDetallePageState extends State<DeudaDetallePage> {
  bool loading = true;
  String? error;
  DeudaDetalle? detalle;

  @override
  void initState() {
    super.initState();
    cargarDetalle();
  }

  Future<void> cargarDetalle() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final data = await DeudasService.obtenerDetallePorCliente(widget.deuda.clienteId);
      if (!mounted) return;
      setState(() {
        detalle = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'No se pudo cargar el detalle de la deuda.';
        loading = false;
      });
    }
  }

  Future<void> eliminarDeuda() async {
    if (detalle == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar pago'),
          content: const Text('¿Deseas eliminar esta deuda como pagada?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí, eliminar')),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await DeudasService.eliminarDeuda(detalle!.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar deuda: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la deuda')),
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
                        ElevatedButton(onPressed: cargarDetalle, child: const Text('Reintentar')),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.deuda.nombre, style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Text(widget.deuda.telefono, style: const TextStyle(fontSize: 16.0)),
                      const SizedBox(height: 20.0),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Información de deuda', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12.0),
                              _DetailRow(label: 'ID de deuda', value: detalle!.id.toString()),
                              _DetailRow(label: 'Total adeudado', value: '\$${detalle!.total.toStringAsFixed(2)}'),
                              _DetailRow(label: 'Estado', value: detalle!.estado),
                              _DetailRow(label: 'Fecha pago', value: detalle!.fechaPago ?? 'No registrada'),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: eliminarDeuda,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Marcar como pagado'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48.0)),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _InfoCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170.0,
      child: Card(
        color: color.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14.0),
              Text(value, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: color)),
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(title, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

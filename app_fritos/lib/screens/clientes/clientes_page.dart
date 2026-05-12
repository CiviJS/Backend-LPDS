import 'package:flutter/material.dart';
import '../../models/cliente.dart';
import '../../services/Cliente_service.dart';
import 'crear_Cliente_page.dart';
import 'editar_Cliente_page.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<Cliente> clientes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    final data = await ClienteService.getClientes();
    setState(() {
      clientes = data;
      loading = false;
    });
  }

  Future<void> eliminar(int id) async {
    await ClienteService.eliminarCliente(id);
    cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clientes")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearclientePage()),
          );
          cargar();
        },
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (_, i) {
                final c = clientes[i];
                return ListTile(
                  title: Text(c.nombre),
                  subtitle: Text("\$${c.telefono}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarClientePage(cliente: c),
                            ),
                          );
                          cargar();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => eliminar(c.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
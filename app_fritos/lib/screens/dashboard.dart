import 'package:flutter/material.dart';
import 'productos/productos_page.dart';
import 'clientes/clientes_page.dart';
import 'ventas_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("La Parada Del Sabor"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Venta',),
              Tab(text: 'Cliente',),
              Tab(text: 'Productos'),
              Tab(text: 'Reportes')
              ]),
        ), body: const TabBarView(children: [
            Center(child: VentasPage(),),
            Center(child: ClientesPage()),
            Center(child: ProductosPage()),
            Center(child: Text('Vista de Reportes')),
          ],
        ),
      ),
    );
  }
}

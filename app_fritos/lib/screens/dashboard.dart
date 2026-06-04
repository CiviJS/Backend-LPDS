import 'package:flutter/material.dart';
import 'productos/productos_page.dart';
import 'clientes/clientes_page.dart';
import 'ventas/ventas_page.dart';
import 'deudas/deudas_page.dart';
import 'reportes/reportes_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("La Parada Del Sabor"),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Venta'),
              Tab(text: 'Cliente'),
              Tab(text: 'Productos'),
              Tab(text: 'Deudas'),
              Tab(text: 'Reportes'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            VentasPage(),
            ClientesPage(),
            ProductosPage(),
            DeudasPage(),
            ReportesPage(),
          ],
        ),
      ),
    );
  }
}

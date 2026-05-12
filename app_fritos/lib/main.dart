import 'package:flutter/material.dart';
import 'screens/productos/productos_page.dart';
import 'screens/clientes/clientes_page.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'la parada del sabor',
      initialRoute: "/",
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
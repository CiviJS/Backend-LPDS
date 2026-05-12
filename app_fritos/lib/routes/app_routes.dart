import 'package:flutter/material.dart';

// DASHBOARD
import '../screens/dashboard.dart';

// CLIENTES
import '../screens/clientes/clientes_page.dart';
import '../screens/clientes/crear_cliente_page.dart';
import '../screens/clientes/editar_cliente_page.dart';
import '../models/cliente.dart';

// PRODUCTOS
import '../screens/productos/productos_page.dart';
import '../screens/productos/crear_producto_page.dart';
import '../screens/productos/editar_producto_page.dart';
import '../models/producto.dart';

class AppRoutes {
  // DASHBOARD
  static const String dashboard = '/';

  // CLIENTES
  static const String clientes = '/clientes';
  static const String crearCliente = '/clientes/crear';
  static const String editarCliente = '/clientes/editar';

  // PRODUCTOS
  static const String productos = '/productos';
  static const String crearProducto = '/productos/crear';
  static const String editarProducto = '/productos/editar';

  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      // DASHBOARD
      case dashboard:
        return MaterialPageRoute(builder: (_) => Dashboard());

      // PRODUCTOS
      case productos:
        return MaterialPageRoute(builder: (_) => ProductosPage());

      case crearProducto:
        return MaterialPageRoute(builder: (_) => CrearProductoPage());

      case editarProducto:
      if (settings.arguments == null){
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body:Center(child: Text('Error : Producto no enviado')),
          ),
        );
      }
        final producto = settings.arguments;
      if (producto is! Producto) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Argumentos Invalidos.')),
          )
        );
      }
           return MaterialPageRoute(
            builder: (_) => EditarProductoPage(producto: producto),
          );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ProductoService {
  static const String baseUrl = "http://localhost:3000/api/productos";

  // GET
  static Future<List<Producto>> getProductos() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List lista = data["data"] ?? data["productos"];
      return lista.map((e) => Producto.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener productos");
    }
  }

  // POST
  static Future<void> crearProducto(String nombre, double precio) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "nombre": nombre,
        "precio_sugerido": precio,
        "activo": 1
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Error al crear producto");
    }
  }

  // PUT
  static Future<void> actualizarProducto(Producto p) async {
    final res = await http.put(
      Uri.parse("$baseUrl/${p.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "nombre": p.nombre,
        "precio_sugerido": p.precio,
        "activo": p.activo
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Error al actualizar");
    }
  }

  // DELETE
  static Future<void> eliminarProducto(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));

    if (res.statusCode != 200) {
      throw Exception("Error al eliminar");
    }
  }
}
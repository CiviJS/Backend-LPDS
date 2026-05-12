import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';

class ClienteService {
  static const String baseUrl = "http://localhost:3000/api/Clientes";

  // GET
  static Future<List<Cliente>> getClientes() async {
  final res = await http.get(Uri.parse(baseUrl));

  final data = json.decode(res.body);
  final List lista = data["data"];

  return lista.map((e) => Cliente.fromJson(e)).toList();        
}

    static Future<Cliente> getClientePorId(int id) async {
    final res = await http.get(Uri.parse("$baseUrl/$id"));

    if (res.statusCode == 200) {
        final data = json.decode(res.body);

        return Cliente.fromJson(data["data"] ?? data);
    } else {
        throw Exception("Error al obtener cliente");
    }
    }
  // POST
  static Future<void> crearCliente(String nombre, String telefono) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "nombre": nombre,
        "telefono": telefono
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Error al crear Cliente");
    }
  }

  // PUT
  static Future<void> actualizarCliente(Cliente p) async {
    final res = await http.put(
      Uri.parse("$baseUrl/${p.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "nombre": p.nombre,
        "telefono": p.telefono
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Error al actualizar");
    }
  }

  // DELETE
  static Future<void> eliminarCliente(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));

    if (res.statusCode != 200) {
      throw Exception("Error al eliminar");
    }
  }
}
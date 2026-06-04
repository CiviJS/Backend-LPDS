import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/Environment.dart';
import '../models/deuda.dart';

class DeudasService {
  static const String baseUrl = '${Environment.apiBaseUrl}/deudas';

  static Future<List<Deuda>> obtenerDeudas() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode != 200) {
      final responseBody = res.body.isNotEmpty ? jsonDecode(res.body) : {};
      throw Exception(responseBody['message'] ?? 'Error al obtener las deudas');
    }

    final data = jsonDecode(res.body);
    return (data['data'] as List).map((e) => Deuda.fromJson(e)).toList();
  }

  static Future<DeudaDetalle> obtenerDetallePorCliente(int clienteId) async {
    final res = await http.get(Uri.parse('$baseUrl/$clienteId'));

    if (res.statusCode != 200) {
      final responseBody = res.body.isNotEmpty ? jsonDecode(res.body) : {};
      throw Exception(responseBody['message'] ?? 'No se encontró la deuda');
    }

    final data = jsonDecode(res.body);
    return DeudaDetalle.fromJson(data['data']);
  }

  static Future<void> crearDeuda(int clienteId, List<Map<String, dynamic>> productos) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cliente_id': clienteId,
        'productos': productos,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      final responseBody = res.body.isNotEmpty ? jsonDecode(res.body) : {};
      throw Exception(responseBody['message'] ?? 'Error al crear la deuda');
    }
  }

  static Future<void> eliminarDeudaPorCliente(int clienteId) async {
    final detalle = await obtenerDetallePorCliente(clienteId);
    await eliminarDeuda(detalle.id);
  }

  static Future<void> eliminarDeuda(int deudaId) async {
    final res = await http.delete(Uri.parse('$baseUrl/$deudaId'));

    if (res.statusCode != 200) {
      final responseBody = res.body.isNotEmpty ? jsonDecode(res.body) : {};
      throw Exception(responseBody['message'] ?? 'Error al eliminar la deuda');
    }
  }
}

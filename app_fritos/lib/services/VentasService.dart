import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ventaReporte.dart';
import '../models/venta.dart';
import 'package:flutter/material.dart';
import '../config/Environment.dart';

class VentasService {
  static const String baseUrl = Environment.apiBaseUrl + "/Ventas";

  // 1. Registrar Ventas
  static Future<List<VentaReporte>> obtenerVentas() async {
    final res = await http.get(Uri.parse(baseUrl));
    // Para depuración: muestra la respuesta completa del servidor
    final data = jsonDecode(res.body);
    return (data["data"] as List).map((e) => VentaReporte.fromJson(e)).toList();
  }

  static Future<void> registrarVentas(
    BuildContext context,
    List<Venta> listaDeVentas,
  ) async {
    try {
      final cuerpoPeticion = jsonEncode({
        "ventas": listaDeVentas.map((venta) => venta.toJson()).toList(),
      });

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"content-type": "application/json"},
        body: cuerpoPeticion,
      );

      // Usamos el comprobador y le pasamos el mensaje de éxito correspondiente
      comprobarRespuesta(response, context, 'Ventas registradas con éxito');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión al registrar ventas')),
      );
    }
  }

  // 2. Eliminar Venta por ID de Producto
  static Future<void> desHacerVentaByProducto(
    BuildContext context,
    int productoid,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$productoid'),
        headers: {"content-type": "application/json"},
      );
      
      // Usamos el mismo comprobador con su propio mensaje de éxito
      comprobarRespuesta(response, context, 'Venta eliminada con éxito');
        
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión al eliminar la venta')),
      );
    }
  }

  // 3. Método ayudante para comprobar el estado de la respuesta de internet
  static void comprobarRespuesta(http.Response response, BuildContext context, String mensajeExito) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensajeExito)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ups! ${jsonDecode(response.body)['message']}',
          ),
        ),
      );
    }
  }
}
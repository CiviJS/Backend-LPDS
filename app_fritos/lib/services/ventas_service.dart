import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venta.dart';
import 'package:flutter/material.dart';
class VentasService {
  static const String baseUrl = "http://localhost:3000/api/Clientes";

  static Future<void> registrarVenta(BuildContext context ,Venta v) async {
    try {
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"content-type": "application/json"},
        body: jsonEncode({
          "ventas": [v.toJson()]
        })
        );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Si el PHP responde OK, actualizamos el contador local
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venta registrada con éxito')),
      );
    } else {
      print('Error en el servidor: ${response.body}');
    }
    } catch (e) {
      print('error: $e');
    }
  }
}

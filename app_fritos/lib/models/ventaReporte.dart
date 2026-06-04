// models/venta.dart
class VentaReporte {
  final int id;
  final String nombre;
  final double precioSugerido;
  final int activo;
  final int totalVendidoHoy;
  final List<dynamic> ventasHoy; // Aquí se guardan los detalles de cada venta por si los necesitas

  VentaReporte({
    required this.id,
    required this.nombre,
    required this.precioSugerido,
    required this.activo,
    required this.totalVendidoHoy,
    required this.ventasHoy,
  });

  factory VentaReporte.fromJson(Map<String, dynamic> json) {
    return VentaReporte(
      id: json['id'],
      nombre: json['nombre'],
      precioSugerido: double.parse(json['precio_sugerido'].toString()),
      activo: json['activo'],
      // Nos aseguramos de parsearlo a int por si la BD lo manda como string o formato raro
      totalVendidoHoy: int.parse(json['total_vendido_hoy'].toString()), 
      ventasHoy: json['ventas_hoy'] ?? [],
    );
  }
}
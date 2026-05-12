class Producto {
  final int id;
  final String nombre;
  final double precio;
  final int activo;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.activo,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json["id"],
      nombre: json["nombre"],
      precio: double.parse(json["precio_sugerido"].toString()),
      activo: json["activo"] ?? 1,
    );
  }
}
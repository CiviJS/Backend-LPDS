class Producto {
  final int id;
  final String nombre;
  final double precio;
  final int activo;
  final int cantidadInicial;
  final int cantidadActual;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.activo,
    required this.cantidadInicial,
    required this.cantidadActual
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json["id"],
      nombre: json["nombre"],
      precio: double.parse(json["precio_sugerido"].toString()),
      activo: json["activo"] ?? 1,
      cantidadInicial: json["cantidad_inicial"] ?? 0,
      cantidadActual: json["cantidad_actual"] ?? 0
    );
  }
}
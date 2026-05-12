class Venta {
  final int productoId;
  final int cantidad;
  final double precioUnitario;

  Venta({
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      productoId: json["producto_id"],
      cantidad: json["cantidad"],
      precioUnitario: double.parse(json["precio_unitario"].toString())
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "producto_id":productoId,
      "cantidad": cantidad,
      "precio_unitario": precioUnitario
    };
  }
  
}
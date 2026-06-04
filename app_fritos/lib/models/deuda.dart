class Deuda {
  final int clienteId;
  final String nombre;
  final String telefono;
  final double totalDeuda;

  Deuda({
    required this.clienteId,
    required this.nombre,
    required this.telefono,
    required this.totalDeuda,
  });

  factory Deuda.fromJson(Map<String, dynamic> json) {
    return Deuda(
      clienteId: json['cliente_id'],
      nombre: json['nombre']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      totalDeuda: double.parse(json['total_deuda'].toString()),
    );
  }
}

class DeudaDetalle {
  final int id;
  final int clienteId;
  final double total;
  final String estado;
  final String? fechaPago;

  DeudaDetalle({
    required this.id,
    required this.clienteId,
    required this.total,
    required this.estado,
    this.fechaPago,
  });

  factory DeudaDetalle.fromJson(Map<String, dynamic> json) {
    return DeudaDetalle(
      id: json['id'],
      clienteId: json['cliente_id'],
      total: double.parse(json['total'].toString()),
      estado: json['estado']?.toString() ?? 'pendiente',
      fechaPago: json['fecha_pago']?.toString(),
    );
  }
}

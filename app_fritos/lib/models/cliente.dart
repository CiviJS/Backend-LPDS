class Cliente {
  final int id;
  final String nombre;
  final String telefono;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,

  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json["id"],
      nombre: json["nombre"],
      telefono: json["telefono"],
    );
  }
}
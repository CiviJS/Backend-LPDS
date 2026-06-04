const db = require("../config/db");

const crearProductoService = async (data) => {
  const { nombre, precio_sugerido } = data;

  const [result] = await db.execute(
    "INSERT INTO productos (nombre,precio_sugerido) VALUES (?, ?)", [nombre, precio_sugerido]
  );
  return {
    id: result.insertId,
    nombre,
    precio_sugerido
  };
};

const obtenerProductosService = async () => {
  
  const [result] = await db.execute(`SELECT 
        p.id,
        p.nombre,
        p.precio_sugerido,
        p.activo,
        p.created_at,
        COALESCE(i.cantidad_inicial, 0) AS cantidad_inicial,
        COALESCE(i.cantidad_actual, 0) AS cantidad_actual,
        i.fecha
    FROM productos p
    LEFT JOIN inventario_diario i 
        ON p.id = i.id_producto AND i.fecha = CURDATE()
    WHERE p.activo = 1; `);

    if (result.length === 0) {
        throw new Error("Producto no existe");
    }
  return result
}

const buscarProductoService = async (id) => {
  const [result] = await db.execute("SELECT id, nombre, precio_sugerido, activo, created_at FROM productos WHERE id = ?", [id])
  if (result.length === 0) {
    throw new Error("Producto no existe");
  }
  return result[0]
}

const actualizarProductoService = async (id, data) => {
  const { nombre, precio_sugerido, activo, cantidad_inicial, cantidad_actual } = data;

  // 1. Actualizamos los datos fijos en la tabla productos
  const [result] = await db.execute(
    `UPDATE productos 
     SET nombre = ?, precio_sugerido = ?, activo = ?
     WHERE id = ?`,
    [nombre, precio_sugerido, activo, id]
  );

  if (result.affectedRows === 0) {
    throw new Error("Producto no encontrado");
  }

  await db.execute(
    `INSERT INTO inventario_diario (id_producto, cantidad_inicial, cantidad_actual, fecha)
     VALUES (?, ?, ?, CURDATE())
     ON DUPLICATE KEY UPDATE 
        cantidad_inicial = VALUES(cantidad_inicial),
        cantidad_actual = VALUES(cantidad_actual)`,
    [id, cantidad_inicial, cantidad_actual]
  );

  return {
    id,
    nombre,
    precio_sugerido,
    activo,
    cantidad_inicial,
    cantidad_actual
  };
};

//eliminar con ID
const eliminarProductoService = async (id) => {
  const [result] = await db.execute(
    "UPDATE productos SET activo = 0 WHERE id = ?",
    [id]
  );
  if (result.affectedRows === 0) {
    throw new Error("Producto no existe");
  }
  return
}

module.exports = {
  crearProductoService,
  obtenerProductosService,
  buscarProductoService,
  actualizarProductoService,
  eliminarProductoService
};
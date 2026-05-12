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
  const [result] = await db.execute("SELECT id, nombre, precio_sugerido, activo, created_at FROM productos");
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
  const { nombre, precio_sugerido, activo } = data;

  

  const [result] = await db.execute(
    `UPDATE productos 
     SET nombre = ?, precio_sugerido = ?, activo = ?
     WHERE id = ?`,
    [nombre, precio_sugerido, activo, id]
  );
  if (result.affectedRows   === 0) {
    throw new Error("Producto no encontrado");
  }

  return {
    id,
    nombre,
    precio_sugerido,
    activo
  };
};

const eliminarProductoService = async (id) => {
  const [result] = await db.execute(
    "UPDATE productos SET activo = 0 WHERE id = ?",
    [id]
  );
  if (result.affectedRows   === 0) {
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
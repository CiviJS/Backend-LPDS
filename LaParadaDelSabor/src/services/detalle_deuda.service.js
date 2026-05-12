const db = require("../config/db");

const crearDetalleDeudaService = async (data) => {
  const { deuda_id, producto_id, cantidad, precio_unitario } = data;

  const [result] = await db.execute(
    `INSERT INTO detalle_deuda (deuda_id, producto_id, cantidad, precio_unitario)
     VALUES (?, ?, ?, ?)`,
    [deuda_id, producto_id, cantidad, precio_unitario]
  );

  return {
    id: result.insertId,
    deuda_id,
    producto_id,
    cantidad,
    precio_unitario
  };
};

const obtenerDetalleDeudaService = async () => {
  const [result] = await db.execute(
    `SELECT dd.id, dd.cantidad, dd.precio_unitario, dd.fecha,
            p.nombre AS producto,
            d.id AS deuda_id
     FROM detalle_deuda dd
     JOIN productos p ON dd.producto_id = p.id
     JOIN deudas d ON dd.deuda_id = d.id`
  );

  return result;
};

const buscarDetalleDeudaService = async (id) => {
  const [result] = await db.execute(
    "SELECT * FROM detalle_deuda WHERE id = ?",
    [id]
  );

  if (result.length === 0) {
    throw new Error("Detalle de deuda no existe");
  }

  return result[0];
};

const actualizarDetalleDeudaService = async (id, data) => {
  const { cantidad, precio_unitario } = data;

  const [result] = await db.execute(
    `UPDATE detalle_deuda 
     SET cantidad = ?, precio_unitario = ?
     WHERE id = ?`,
    [cantidad, precio_unitario, id]
  );

  if (result.affectedRows === 0) {
    throw new Error("Detalle de deuda no existe");
  }

  return {
    id,
    cantidad,
    precio_unitario
  };
};

const eliminarDetalleDeudaService = async (id) => {
  const [result] = await db.execute(
    "DELETE FROM detalle_deuda WHERE id = ?",
    [id]
  );

  if (result.affectedRows === 0) {
    throw new Error("Detalle de deuda no existe");
  }

  return true;
};

module.exports = {
  crearDetalleDeudaService,
  obtenerDetalleDeudaService,
  buscarDetalleDeudaService,
  actualizarDetalleDeudaService,
  eliminarDetalleDeudaService
};
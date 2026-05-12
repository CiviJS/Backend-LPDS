const db = require("../config/db");

const crearDeudaService = async (data) => {
  const { cliente_id, total } = data;

  const [result] = await db.execute(
    "INSERT INTO deudas (cliente_id, total) VALUES (?, ?)",
    [cliente_id, total]
  );

  return {
    id: result.insertId,
    cliente_id,
    total,
    estado: "pendiente"
  };
};

const obtenerDeudasService = async () => {
  const [result] = await db.execute(
    `SELECT d.id, d.total, d.estado, d.fecha_inicio, c.nombre AS cliente
     FROM deudas d
     JOIN clientes c ON d.cliente_id = c.id`
  );

  return result;
};

const buscarDeudaService = async (id) => {
  const [result] = await db.execute(
    "SELECT * FROM deudas WHERE id = ?",
    [id]
  );

  if (result.length === 0) {
    throw new Error("Deuda no existe");
  }

  return result[0];
};

const actualizarDeudaService = async (id, data) => {
  const { total, estado, fecha_pago } = data;

  const [result] = await db.execute(
    `UPDATE deudas 
     SET total = ?, estado = ?, fecha_pago = ?
     WHERE id = ?`,
    [total, estado, fecha_pago, id]
  );

  if (result.affectedRows === 0) {
    throw new Error("Deuda no existe");
  }

  return {
    id,
    total,
    estado,
    fecha_pago
  };
};

const eliminarDeudaService = async (id) => {
  const [result] = await db.execute(
    "DELETE FROM deudas WHERE id = ?",
    [id]
  );

  if (result.affectedRows === 0) {
    throw new Error("Deuda no existe");
  }

  return true;
};

module.exports = {
  crearDeudaService,
  obtenerDeudasService,
  buscarDeudaService,
  actualizarDeudaService,
  eliminarDeudaService
};
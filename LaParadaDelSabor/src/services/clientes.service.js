const db = require("../config/db");

const crearClienteService = async (data) => {
  const { nombre, telefono } = data;

  const [result] = await db.execute(
    "INSERT INTO clientes (nombre, telefono) VALUES (?, ?)",
    [nombre, telefono]
  );

  return {
    id: result.insertId,
    nombre,
    telefono
  };
};

const obtenerClientesService = async () => {
  const [result] = await db.execute(
    "SELECT id, nombre, telefono, created_at FROM clientes"
  );
  return result;
};

const buscarClienteService = async (id) => {
  const [result] = await db.execute(
    "SELECT id, nombre, telefono, created_at FROM clientes WHERE id = ?",
    [id]
  );

  if (result.length === 0) {
    throw new Error("Cliente no existe");
  }

  return result[0];
};

const actualizarClienteService = async (id, data) => {
  const { nombre, telefono } = data;

  const [result] = await db.execute(
    "UPDATE clientes SET nombre = ?, telefono = ? WHERE id = ?",
    [nombre, telefono, id]
  );

  if (result.affectedRows === 0) {
    throw new Error("Cliente no existe");
  }

  return {
    id,
    nombre,
    telefono
  };
};

const eliminarClienteService = async (id) => {
  const [result] = await db.execute(
    "DELETE FROM clientes WHERE id = ?",
    [id]
  );

  if (result.affectedRows === 0) {
    throw new Error("Cliente no existe");
  }

  return true;
};

module.exports = {
  crearClienteService,
  obtenerClientesService,
  buscarClienteService,
  actualizarClienteService,
  eliminarClienteService
};
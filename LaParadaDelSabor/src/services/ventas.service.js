const db = require("../config/db");


const crearVentaService = async (data) => {
  if (!Array.isArray(data)) {
    throw new Error("Se esperaba un arreglo de ventas");
  }

  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    const resultados = [];

    for (const item of data) {
      const { producto_id, cantidad, precio_unitario } = item;

      const [result] = await conn.execute(
        "INSERT INTO ventas (producto_id, cantidad, precio_unitario) VALUES (?, ?, ?)",
        [producto_id, cantidad, precio_unitario]
      );

      resultados.push({
        id: result.insertId,
        producto_id,
        cantidad,
        precio_unitario
      });
    }

    await conn.commit();
    return resultados;

  } catch (error) {
    await conn.rollback();
    throw error;

  } finally {
    conn.release();
  }
};



const obtenerVentasService = async () => {
    const [result] = await db.execute(
        `SELECT v.id, v.cantidad, v.precio_unitario, v.fecha, p.nombre AS producto
     FROM ventas v
     JOIN productos p ON v.producto_id = p.id`
    );

    return result;
};

const buscarVentaService = async (id) => {
    const [result] = await db.execute(
        "SELECT * FROM ventas WHERE id = ?",
        [id]
    );

    if (result.length === 0) {
        throw new Error("Venta no existe");
    }

    return result[0];
};

const actualizarVentaService = async (id, data) => {
    const { cantidad, precio_unitario } = data;

    const [result] = await db.execute(
        `UPDATE ventas 
     SET cantidad = ?, precio_unitario = ?
     WHERE id = ?`,
        [cantidad, precio_unitario, id]
    );

    if (result.affectedRows === 0) {
        throw new Error("Venta no existe");
    }

    return {
        id,
        cantidad,
        precio_unitario
    };
};

const eliminarVentaService = async (id) => {
    const [result] = await db.execute(
        "DELETE FROM ventas WHERE id = ?",
        [id]
    );

    if (result.affectedRows === 0) {
        throw new Error("Venta no existe");
    }

    return true;
};

module.exports = {
    crearVentaService,
    obtenerVentasService,
    buscarVentaService,
    actualizarVentaService,
    eliminarVentaService
};
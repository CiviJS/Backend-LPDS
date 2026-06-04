const db = require("../config/db");


const {
  crearDetalleDeudaService,
  obtenerDetalleDeudaService,
  buscarDetalleDeudaService,
  actualizarDetalleDeudaService,
  eliminarDetalleDeudaService
} = require("../services/detalle_deuda.service");


// {"data": "cliente_id" : id , "productos":[{"id_producto": 1, "cantidad"}]}



const crearDeudaService = async (data) => {
  const { cliente_id, productos } = data;

  // 1. Calcular el total
  let productoID = []
  for (const producto of productos) {
    productoID.push(producto.id);
  }

  // 2. Pedir una conexión limpia para la transacción
  const connection = await db.getConnection();

  try {
    // Iniciamos la transacción (Si algo falla aquí dentro, nada se guarda)
    await connection.beginTransaction();
    const [productosEncontrados] = await connection.query(
      `SELECT id, precio_sugerido FROM productos WHERE id IN (?)`, [productoID]
    );

    if (productosEncontrados.length !== productos.length) {
      throw new Error("Producto no encontrado");
    }
    const preciosMap = productosEncontrados.reduce((mapa, prod) => {
      mapa[prod.id] = prod.precio_sugerido;
      return mapa
    }, {});


    const total = productos.reduce((acc, prod) => {
      const precio = preciosMap[prod.id];
      return acc + (precio * prod.cantidad);
    }, 0);



    // Insertar la cabecera de la deuda
    const [result] = await connection.execute(
      "INSERT INTO deudas (cliente_id, total) VALUES (?, ?)",
      [cliente_id, total]
    );

    const deudaId = result.insertId;

    // Insertar los detalles usando la MISMA conexión de la transacción
    for (const producto of productos) {
      // Aquí el await SÍ va a frenar el bucle hasta que este producto se inserte
      await crearDetalleDeudaService({
        deuda_id: deudaId,
        producto_id: producto.id,
        cantidad: producto.cantidad,
        precio_unitario: preciosMap[producto.id]
      }, connection);
    }

    // Si todo salió bien, guardamos los cambios definitivamente
    await connection.commit();

    return {
      id: deudaId,
      cliente_id,
      total,
      estado: "pendiente"
    };

  } catch (error) {
    // Si algo falló (así sea un solo producto), borramos todo lo que se intentó hacer
    await connection.rollback();
    throw error; // Re-lanzamos el error para que el controlador lo maneje
  } finally {
    // Siempre, pase lo que pase, liberamos la conexión
    connection.release();
  }
};

const obtenerDeudasService = async () => {
  const [result] = await db.execute(
    `SELECT c.id as cliente_id, c.nombre, c.telefono, SUM(d.total) as total_deuda
    FROM deudas d 
    LEFT JOIN clientes c ON d.cliente_id = c.id
    GROUP BY c.id, c.nombre, c.telefono;
    `
  );
  return result;
};
const buscarDeudaServiceByCliente = async (id) => {
  const [result] = await db.execute(
    "SELECT * FROM deudas WHERE cliente_id = ? ",
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
  buscarDeudaServiceByCliente,
  actualizarDeudaService,
  eliminarDeudaService
};
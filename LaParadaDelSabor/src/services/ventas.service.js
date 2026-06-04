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

            const [inventario] = await conn.execute(
                `UPDATE inventario_diario set cantidad_actual = cantidad_actual - 1 WHERE id_producto = ? AND cantidad_actual > 0 AND fecha = CURDATE() `, [producto_id]
            );
            
            if(inventario.affectedRows === 0){
                throw new Error("No hay productos en stock! ")

            }
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
    //optimizacion necesaria por que se hace una consulta por cada producto para obtener sus ventas del dia con joins y subconsultas..
    //necesidad urgente de escalar esto en repositorys implementando Interfaces para desacoplay mysql..

    //[
    //   {
    //     "id": 1,
    //     "nombre": "Empanada de Carne",
    //     "precio_sugerido": "2000.00",
    //     "activo": 1,
    //     "total_vendido_hoy": 8,
    //     "ventas_hoy": [
    //       {
    //         "id": 12,
    //         "cantidad": 5,
    //         "precio_unitario": "2000.00",
    //         "fecha": "2024-06-20T14:30:00.000Z" tiempo en formato ISO 8601 OBLIGATORIO para que flutter lo pueda parsear a DateTime
    //       },
    //]

    const [result] = await db.execute(
        `SELECT 
            p.id, 
            p.nombre, 
            p.precio_sugerido,
            p.activo,
            COALESCE(SUM(v.cantidad), 0) AS total_vendido_hoy,
            COALESCE(
                (
                    SELECT JSON_ARRAYAGG(
                        JSON_OBJECT(
                            'id', v2.id,
                            'cantidad', v2.cantidad,
                            'precio_unitario', v2.precio_unitario,
                            'fecha', v2.fecha
                        )
                    )
                    FROM ventas v2
                    WHERE v2.producto_id = p.id AND DATE(v2.fecha) = CURDATE()
                ), 
                JSON_ARRAY()
            ) AS ventas_hoy
        FROM productos p
        LEFT JOIN ventas v ON p.id = v.producto_id AND DATE(v.fecha) = CURDATE()
        WHERE p.activo = 1
        GROUP BY p.id, p.nombre, p.precio_sugerido, p.activo;`
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

const eliminarVentaService = async (ProductoId) => {

    const [inventario] = await db.execute(`UPDATE inventario_diario SET cantidad_actual = cantidad_actual 
        + 1 WHERE id_producto = ? AND cantidad_inicial > cantidad_actual AND fecha = CURDATE()`,[ProductoId])
     
        if (inventario.affectedRows === 0) {
        throw new Error("No se pueden deshacer mas ventas!");
    }

    
    const [result] = await db.execute(
        "DELETE FROM ventas WHERE producto_id = ? ORDER BY fecha DESC LIMIT 1 ;",
        [ProductoId]
    );

   
    return true;
};

module.exports = {
    crearVentaService,
    obtenerVentasService,
    buscarVentaService,
    actualizarVentaService,
    eliminarVentaService
};


//edge case

// si un producto esta a 12 de stock inicial pero el stock actual esta en 0 y se registra una venta con ventas en 0, se bugea Xd

// era por la fecha wbn xddddd JJAJAJ
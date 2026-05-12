const {
  crearVentaService,
  obtenerVentasService,
  buscarVentaService,
  actualizarVentaService,
  eliminarVentaService
} = require("../services/ventas.service");

const crearVenta = async (req, res) => {
  try {
    
    const ventas = await crearVentaService(req.body.ventas);

    res.json({ success: true, data: ventas });

  } catch (error) {

    if (error.code === "ER_NO_REFERENCED_ROW_2") {
      return res.status(400).json({
        success: false,
        message: "El producto no existe"
      });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const obtenerVentas = async (req, res) => {
  try {
    const ventas = await obtenerVentasService();

    res.json({ success: true, data: ventas });

  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const buscarVenta = async (req, res) => {
  try {
    const { id } = req.params;

    const venta = await buscarVentaService(id);

    res.json({ success: true, data: venta });

  } catch (error) {

    if (error.message === "Venta no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const actualizarVenta = async (req, res) => {
  try {
    const { id } = req.params;

    const venta = await actualizarVentaService(id, req.body);

    res.json({ success: true, data: venta });

  } catch (error) {

    if (error.message === "Venta no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const eliminarVenta = async (req, res) => {
  try {
    const { id } = req.params;

    await eliminarVentaService(id);

    res.json({
      success: true,
      message: "Venta eliminada correctamente"
    });

  } catch (error) {

    if (error.message === "Venta no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  crearVenta,
  obtenerVentas,
  buscarVenta,
  actualizarVenta,
  eliminarVenta
};
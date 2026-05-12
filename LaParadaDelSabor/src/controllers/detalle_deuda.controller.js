const {
  crearDetalleDeudaService,
  obtenerDetalleDeudaService,
  buscarDetalleDeudaService,
  actualizarDetalleDeudaService,
  eliminarDetalleDeudaService
} = require("../services/detalle_deuda.service");

const crearDetalleDeuda = async (req, res) => {
  try {
    const detalle = await crearDetalleDeudaService(req.body);

    res.json({ success: true, data: detalle });

  } catch (error) {

    if (error.code === "ER_NO_REFERENCED_ROW_2") {
      return res.status(400).json({
        success: false,
        message: "Deuda o producto no existe"
      });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const obtenerDetalleDeuda = async (req, res) => {
  try {
    const detalles = await obtenerDetalleDeudaService();

    res.json({ success: true, data: detalles });

  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const buscarDetalleDeuda = async (req, res) => {
  try {
    const { id } = req.params;

    const detalle = await buscarDetalleDeudaService(id);

    res.json({ success: true, data: detalle });

  } catch (error) {

    if (error.message === "Detalle de deuda no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const actualizarDetalleDeuda = async (req, res) => {
  try {
    const { id } = req.params;

    const detalle = await actualizarDetalleDeudaService(id, req.body);

    res.json({ success: true, data: detalle });

  } catch (error) {

    if (error.message === "Detalle de deuda no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const eliminarDetalleDeuda = async (req, res) => {
  try {
    const { id } = req.params;

    await eliminarDetalleDeudaService(id);

    res.json({
      success: true,
      message: "Detalle eliminado correctamente"
    });

  } catch (error) {

    if (error.message === "Detalle de deuda no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  crearDetalleDeuda,
  obtenerDetalleDeuda,
  buscarDetalleDeuda,
  actualizarDetalleDeuda,
  eliminarDetalleDeuda
};
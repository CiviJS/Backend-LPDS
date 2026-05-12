const {
  crearDeudaService,
  obtenerDeudasService,
  buscarDeudaService,
  actualizarDeudaService,
  eliminarDeudaService
} = require("../services/deudas.service");

const crearDeuda = async (req, res) => {
  try {
    const deuda = await crearDeudaService(req.body);

    res.json({ success: true, data: deuda });

  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const obtenerDeudas = async (req, res) => {
  try {
    const deudas = await obtenerDeudasService();

    res.json({ success: true, data: deudas });

  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const buscarDeuda = async (req, res) => {
  try {
    const { id } = req.params;

    const deuda = await buscarDeudaService(id);

    res.json({ success: true, data: deuda });

  } catch (error) {

    if (error.message === "Deuda no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const actualizarDeuda = async (req, res) => {
  try {
    const { id } = req.params;

    const deuda = await actualizarDeudaService(id, req.body);

    res.json({ success: true, data: deuda });

  } catch (error) {

    if (error.message === "Deuda no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const eliminarDeuda = async (req, res) => {
  try {
    const { id } = req.params;

    await eliminarDeudaService(id);

    res.json({
      success: true,
      message: "Deuda eliminada correctamente"
    });

  } catch (error) {

    if (error.message === "Deuda no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  crearDeuda,
  obtenerDeudas,
  buscarDeuda,
  actualizarDeuda,
  eliminarDeuda
};
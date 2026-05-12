const {
  crearClienteService,
  obtenerClientesService,
  buscarClienteService,
  actualizarClienteService,
  eliminarClienteService
} = require("../services/clientes.service");

const crearCliente = async (req, res) => {
  try {
    const cliente = await crearClienteService(req.body);

    res.json({
      success: true,
      data: cliente
    });

  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const obtenerClientes = async (req, res) => {
  try {
    const clientes = await obtenerClientesService();

    res.json({ success: true, data: clientes });

  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const buscarCliente = async (req, res) => {
  try {
    const { id } = req.params;

    const cliente = await buscarClienteService(id);

    res.json({ success: true, data: cliente });

  } catch (error) {

    if (error.message === "Cliente no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const actualizarCliente = async (req, res) => {
  try {
    const { id } = req.params;

    const cliente = await actualizarClienteService(id, req.body);

    res.json({ success: true, data: cliente });

  } catch (error) {

    if (error.message === "Cliente no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

const eliminarCliente = async (req, res) => {
  try {
    const { id } = req.params;

    await eliminarClienteService(id);

    res.json({
      success: true,
      message: "Cliente eliminado correctamente"
    });

  } catch (error) {

    if (error.message === "Cliente no existe") {
      return res.status(404).json({ success: false, message: error.message });
    }

    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  crearCliente,
  obtenerClientes,
  buscarCliente,
  actualizarCliente,
  eliminarCliente
};
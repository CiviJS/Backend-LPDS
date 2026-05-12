const express = require("express");
const router = express.Router();

const {
  crearCliente,
  obtenerClientes,
  buscarCliente,
  actualizarCliente,
  eliminarCliente
} = require("../controllers/clientes.controller");

router.get("/", obtenerClientes);
router.get("/:id", buscarCliente);
router.post("/", crearCliente);
router.put("/:id", actualizarCliente);
router.delete("/:id", eliminarCliente);

module.exports = router;
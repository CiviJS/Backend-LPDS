const express = require("express");
const router = express.Router();

const {
  crearVenta,
  obtenerVentas,
  buscarVenta,
  actualizarVenta,
  eliminarVenta
} = require("../controllers/ventas.controller");

router.get("/", obtenerVentas);
router.get("/:id", buscarVenta);
router.post("/", crearVenta);
router.put("/:id", actualizarVenta);
router.delete("/:id", eliminarVenta);

module.exports = router;
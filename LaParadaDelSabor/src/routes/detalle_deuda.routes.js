const express = require("express");
const router = express.Router();

const {
  crearDetalleDeuda,
  obtenerDetalleDeuda,
  buscarDetalleDeuda,
  actualizarDetalleDeuda,
  eliminarDetalleDeuda
} = require("../controllers/detalle_deuda.controller");

router.get("/", obtenerDetalleDeuda);
router.get("/:id", buscarDetalleDeuda);
router.post("/", crearDetalleDeuda);
router.put("/:id", actualizarDetalleDeuda);
router.delete("/:id", eliminarDetalleDeuda);

module.exports = router;
const express = require("express");
const router = express.Router();

const {
  crearDeuda,
  obtenerDeudas,
  buscarDeuda,
  actualizarDeuda,
  eliminarDeuda
} = require("../controllers/deudas.controller");

router.get("/", obtenerDeudas);
router.get("/:id", buscarDeuda);
router.post("/", crearDeuda);
router.put("/:id", actualizarDeuda);
router.delete("/:id", eliminarDeuda);

module.exports = router;
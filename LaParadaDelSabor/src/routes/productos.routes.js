const express = require("express");
const router = express.Router();

const { validarProducto } = require("../validators/producto.validator");
const { crearProducto, obtenerProducto, actualizarProducto, buscarProducto, eliminarProducto } = require("../controllers/productos.controller");

// GET
router.get("/", obtenerProducto);
router.get("/:id", buscarProducto);

// POST correcto
router.post("/", validarProducto, crearProducto);

// PUT
router.put("/:id", validarProducto, actualizarProducto);

router.delete("/:id", eliminarProducto);


module.exports = router;
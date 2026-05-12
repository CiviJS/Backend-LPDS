const validarProducto = (req, res, next) => {
  const { nombre, precio_sugerido,activo } = req.body;

  if (!nombre) {
    return res.status(400).json({ message: "El nombre es obligatorio" });
  }

  if (!precio_sugerido || typeof precio_sugerido !== "number") {
    return res.status(400).json({ message: "Precio inválido" });
  }
  if (activo == undefined || typeof activo !== "number") {
    return res.status(400).json({ message: "Activo invalido" });
  }

  next(); 
};

module.exports = {
  validarProducto
};
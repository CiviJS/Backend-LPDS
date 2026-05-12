const express = require("express");
const cors = require("cors");

const app = express();

// Middlewares básicos
app.use(cors());
app.use(express.json());
app.use("/api/productos", require("./routes/productos.routes"));
app.use("/api/clientes", require("./routes/clientes.routes"));
app.use("/api/deudas", require("./routes/deudas.routes"));
app.use("/api/ventas", require("./routes/ventas.routes"));
app.use("/api/detalle_deuda", require("./routes/detalle_deuda.routes"));

module.exports = app;
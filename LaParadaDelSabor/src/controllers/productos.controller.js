const {
    crearProductoService,
    obtenerProductosService,
    actualizarProductoService,
    buscarProductoService,
    eliminarProductoService
} = require("../services/productos.service");

const crearProducto = async (req, res) => {
    try {
        const producto = await crearProductoService(req.body);

        res.json({
            success: true,
            data: producto
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            data: error.message
        });
    }
};

const obtenerProducto = async (req, res) => {
    try {
      
        const productos = await obtenerProductosService();

        return res.json({
            productos
        });

    } catch (error) {
        if (error.message === "Producto no existe") {
            return res.status(404).json({ message: error.message });
        }

        res.status(500).json({
            success: false,
            data: error.message

        });
    }
};

const buscarProducto = async (req, res) => {
    try {
        const { id } = req.params;
        const producto = await buscarProductoService(id);
        return res.status(200).json({ success: true, data: producto })

    } catch (error) {
        if (error.message === "Producto no existe") {
            return res.status(404).json({ message: error.message });
        }

        res.status(500).json({
            success: false,
            data: error.message
        })

    }

}

const actualizarProducto = async (req, res) => {
    try {
        const { id } = req.params;
        const producto = await buscarProductoService(id);
        const result = await actualizarProductoService(id, req.body);

        res.status(200).json({
            success: true,
            data: producto
        });

    } catch (error) {
        if (error.message === "Producto no existe") {
            return res.status(404).json({ message: error.message });
        }

        res.status(500).json({
            success: false,
            data: error.message
        });
    }
};

const eliminarProducto = async (req, res) => {
    try {
        const { id } = req.params
        const result = await eliminarProductoService(id)
        return res.status(200).json({
            success: true,
            message: result
        });

    } catch (error) {
        if (error.message == "Producto no existe")
            return res.status(404).json({ message: error.message });
        
        res.status(500).json({
            success: false,
            data: error.message
        });
    }
}

module.exports = {
    crearProducto,
    obtenerProducto,
    buscarProducto,
    actualizarProducto,
    eliminarProducto
};
# La Parada del Sabor — API

Documentación básica y profesional de los endpoints disponibles.

Servidor expone la API bajo el prefijo `/api` (puerto por defecto `3000`).

**Endpoints**

- **Productos** (Base: `/api/productos`)
  - `GET /api/productos` : Listar todos los productos.
  - `GET /api/productos/:id` : Obtener un producto por su `id` (param path).
  - `POST /api/productos` : Crear un producto.
    - Body (JSON): `nombre` (string), `precio_sugerido` (number), `activo` (number).
  - `PUT /api/productos/:id` : Actualizar un producto por `id`.
    - Body (JSON): campos a actualizar (mismos campos que en POST).
  - `DELETE /api/productos/:id` : Eliminar un producto por `id`.

- **Clientes** (Base: `/api/clientes`)
  - `GET /api/clientes` : Listar clientes.
  - `GET /api/clientes/:id` : Obtener cliente por `id`.
  - `POST /api/clientes` : Crear cliente.
    - Body (JSON): datos del cliente (p. ej. `nombre`, `telefono`, `email`, etc.).
  - `PUT /api/clientes/:id` : Actualizar cliente por `id`.
  - `DELETE /api/clientes/:id` : Eliminar cliente por `id`.

- **Ventas** (Base: `/api/ventas`)
  - `GET /api/ventas` : Listar ventas.
  - `GET /api/ventas/:id` : Obtener venta por `id`.
  - `POST /api/ventas` : Crear venta.
    - Body (JSON): datos de la venta (p. ej. `clienteId`, `items`, `total`).
  - `PUT /api/ventas/:id` : Actualizar venta por `id`.
  - `DELETE /api/ventas/:id` : Eliminar venta por `id`.

- **Deudas** (Base: `/api/deudas`)
  - `GET /api/deudas` : Listar deudas.
  - `GET /api/deudas/:id` : Obtener deuda por `id`.
  - `POST /api/deudas` : Crear deuda.
    - Body (JSON): datos de la deuda (p. ej. `clienteId`, `monto`, `estado`).
  - `PUT /api/deudas/:id` : Actualizar deuda por `id`.
  - `DELETE /api/deudas/:id` : Eliminar deuda por `id`.

- **Detalle de Deuda** (Base: `/api/detalle_deuda`)
  - `GET /api/detalle_deuda` : Listar detalle de deudas.
  - `GET /api/detalle_deuda/:id` : Obtener detalle por `id`.
  - `POST /api/detalle_deuda` : Crear detalle de deuda.
    - Body (JSON): campos relacionados al detalle (p. ej. `deudaId`, `concepto`, `monto`).
  - `PUT /api/detalle_deuda/:id` : Actualizar detalle por `id`.
  - `DELETE /api/detalle_deuda/:id` : Eliminar detalle por `id`.

**Notas**

- Las respuestas y formatos exactos dependen de los controladores en `src/controllers`.
- Validaciones importantes: `producto` requiere `nombre`, `precio_sugerido` (number) y `activo` (number).
import '../models/ventaReporte.dart';
import 'VentasService.dart';

class ReportesService {
  /// Obtiene la informacion base de ventas desde el servicio existente.
  static Future<List<VentaReporte>> obtenerVentasParaReportes() async {
    return await VentasService.obtenerVentas();
  }
}

import 'package:dio/dio.dart';
import 'package:velvet/config/constants/environment.dart';

class ApiService {
  final Dio _dio = Dio();

  // Constructor que podría utilizarse para configurar Dio globalmente (por ejemplo, tiempos de espera)
  ApiService() {
    _dio.options.baseUrl = Environment.apiUrl;
    _dio.options.connectTimeout = Duration(milliseconds: 5000); // 5 segundos
    _dio.options.receiveTimeout = Duration(milliseconds: 3000); // 3 segundos
    // Puedes añadir configuraciones adicionales aquí
  }

  // Método GET
  Future<dynamic> getRequest(String endpoint, {String? token}) async {
    try {
      var response = await _dio.get(
        endpoint,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Método POST
  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      var response = await _dio.post(
        endpoint,
        data: data,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      print("response es $response");
      print("data es $data");
      return response.data;
    } on DioException catch (e) {
      print("error diopost $e");
      return _handleDioError(e);
    }
  }

  // Método PUT
  Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    try {
      var response = await _dio.put(
        endpoint,
        data: data,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Método DELETE
  Future<dynamic> deleteRequest(String endpoint, {String? token}) async {
    try {
      var response = await _dio.delete(
        endpoint,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return response.data;
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  // Manejador de errores de Dio
  dynamic _handleDioError(DioException e) {
    if (e.response != null) {
      // Hay respuesta del servidor
      print('Error en la solicitud: ${e.response?.data}');
      print('Código de estado: ${e.response?.statusCode}');
      return e.response?.data;
    } else {
      // Error antes de la respuesta del servidor
      print('Error enviando la solicitud: ${e.message}');
      return {'error': 'Error enviando la solicitud: ${e.message}'};
    }
  }
}

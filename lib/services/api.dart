import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvet/enviroment/enviroment.dart';

class ApiController {
  static Future<dynamic> consulta(String url, String method,
      Map<String, dynamic>? body, String? token) async {
    Uri api = Uri.parse("${Enviroment.url}$url");

    final prefs = await SharedPreferences.getInstance();

    String? token1 = prefs.getString('token');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token1'
    };

    // Convertir todos los valores del cuerpo a cadenas si `body` no es nulo
    /*if (body != null) {
      body = body.map((key, value) => MapEntry(key, value.toString()));
    }*/
    //dynamic auxxx =

    switch (method) {
      case 'get':
        return await http.get(api, headers: headers);
      //break;
      case 'post':
        return await http.post(api, headers: headers, body: jsonEncode(body));
      //break;
      case 'put':
        return await http.put(api, headers: headers, body: body);
      //break;
      case 'delete':
        return await http.delete(api, headers: headers);
      //break;
      default:
        return await http.get(api, headers: headers);
    }
  }
}

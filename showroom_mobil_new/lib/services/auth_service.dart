import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.1.10/showroom_api/public'; // ganti IP

  static Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String alamat,
    required String noTelpon,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register.php');

    final response = await http.post(
      url,
      body: {
        'nama': nama,
        'email': email,
        'alamat': alamat,
        'no_telpon': noTelpon,
        'password': password,
      },
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data;
  }
}

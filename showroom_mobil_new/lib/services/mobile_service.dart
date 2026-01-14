import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mobil_model.dart';
import 'auth_service.dart';

class MobilService {
  static const String baseUrl = AuthService.baseUrl;

  static Future<List<MobilModel>> fetchMobilList() async {
    try {
      final url = Uri.parse('$baseUrl/mobil_index.php');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat data mobil. Code: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] != true || data['data'] == null) {
        throw Exception(data['message'] ?? 'Gagal memuat data mobil');
      }

      final List list = data['data'] as List;
      return list.map((item) => MobilModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}

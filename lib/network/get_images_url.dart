import 'dart:convert';
import 'package:http/http.dart' as http;

class GetImagesUrl {
  static Future<List<String>> unsplash() async {
    final response = await http.get(Uri.parse('https://api.unsplash.com/photos/random?client_id=vWyaJXcbm9B5gMyl1ltdd5CJ0YtC-XCH9DS-yL4X9jI&count=10'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map<String>((e) => e['urls']['regular']).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
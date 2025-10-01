import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  Future<Map<String, dynamic>> getWeather(String city) async {
    if (apiKey.isEmpty) throw Exception('OPENWEATHER_API_KEY is not set');

    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Cache response
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('last_weather_$city', json.encode(data));
      return data;
    } else {
      // Try cache
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('last_weather_$city');
      if (cached != null) return json.decode(cached);
      throw Exception('Gagal mengambil data cuaca');
    }
  }
}

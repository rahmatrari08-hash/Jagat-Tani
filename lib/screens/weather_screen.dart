import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String _status = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  void _getWeather() async {
    try {
      final weatherData = await _weatherService.getWeather('Jakarta');
      setState(() {
        _weatherData = weatherData;
        _status = 'OK';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to load weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuaca & Rekomendasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _weatherData == null
            ? Center(child: Text(_status))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // basic weather icon mapping
                          Icon(
                            _getWeatherIcon(_weatherData!['weather'][0]['main']),
                            size: 48,
                            color: theme.primaryColor,
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_weatherData!['name']}', style: theme.textTheme.titleLarge),
                              Text('${_weatherData!['weather'][0]['description']}', style: theme.textTheme.bodyMedium),
                              Text('Suhu: ${_weatherData!['main']['temp']} °C', style: theme.textTheme.bodyMedium),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rekomendasi Pertanian', style: theme.textTheme.titleLarge),
                          SizedBox(height: 8),
                          Text('- Pantau serangan hama jika hujan tinggi', style: theme.textTheme.bodyMedium),
                          SizedBox(height: 6),
                          Text('- Pertimbangkan pemupukan ringkas jika cuaca cerah', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _getWeatherIcon(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.grain; // rain-like icon
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }
}

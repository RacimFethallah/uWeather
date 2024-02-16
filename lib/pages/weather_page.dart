import "package:flutter/material.dart";
import "dart:async";

import "../models/weather_model.dart";
import "../services/weather_service.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API key
  final _weatherService = WeatherService();
  Weather? _weather;

  // Fetch weather data
  _fetchWeather() async {
    // Get current city
    final city = await _weatherService.getCurrentCity();

    // Get weather for that city
    final weather = await _weatherService.getWeather(
      city['latitude'] as double,
      city['longitude'] as double,
    );
    setState(() {
      _weather = Weather(
        city: city['city'],
        temperature: weather.temperature,
        mainCondition: weather.mainCondition,
      );
    });
  }

  // Timer to refresh weather periodically
  Timer? _weatherTimer;

  @override
  void initState() {
    super.initState();
    _fetchWeather();

    // Set up timer to refresh weather every 30 minutes (1800 seconds)
    _weatherTimer = Timer.periodic(const Duration(seconds: 1800), (_) {
      _fetchWeather();
    });
  }

  @override
  void dispose() {
    _weatherTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City name
            Text(
              _weather?.city ?? 'Loading...',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Temperature
            Text(
              '${_weather?.temperature.round() ?? ''}°C',
              style: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Weather condition
            Text(
              _weather?.mainCondition ?? 'Loading...',
              style: const TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import "package:flutter/material.dart";

import "../models/weather_model.dart";
import "../services/weather_service.dart";

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key

  final _weatherService =
      WeatherService(apiKey: '625326cc30ff877f093016f04d5379cb');
  Weather? _weather;

  //fetch weather data

  _fetchWeather() async {
    //get current city
    final city = await _weatherService.getCurrentCity();

    //get weather for that city
    final weather = await _weatherService.getWeather(city);
    setState(() {
      _weather = weather;
    });
  }

  //weather animations

  //initial state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.city ?? 'Loading...'),

            //temperature
            Text(
                '${_weather?.temperature.round().toString()}C'),
          ],
        ),
      ),
    );
  }
}

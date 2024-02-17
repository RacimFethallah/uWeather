import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:uweather/models/hourly_forecast.dart";
import "dart:async";

import '../models/daily_forecast.dart';
import "../models/weather_descriptions.dart";
import "../models/weather_model.dart";
import "../services/weather_service.dart";
import "loadingScreen.dart";

class WeatherPage extends StatefulWidget {
  final Function(ThemeMode) onThemeModeChanged;
  const WeatherPage({Key? key, required this.onThemeModeChanged})
      : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
 
  final _weatherService = WeatherService();
  late Weather _weather;
  String? weatherDescription;
  late Timer? _weatherTimer;
  late Future<Weather> _weatherFuture;
  ThemeMode _currentThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeather();
    _startWeatherTimer();
  }

  @override
  void dispose() {
    _weatherTimer?.cancel();
    super.dispose();
  }

  void _startWeatherTimer() {
    const duration = Duration(seconds: 1800);
    _weatherTimer = Timer.periodic(duration, (_) {
      _fetchWeather();
    });
  }

  Future<Weather> _fetchWeather() async {
    final city = await _weatherService.getCurrentCity();
    final weather = await _weatherService.getWeather(
      city['latitude'] as double,
      city['longitude'] as double,
    );

    setState(() {
      _weather = Weather(
        city: city['city'],
        temperature: weather.temperature,
        conditionText: weather.conditionText,
        code: weather.code,
        hourlyForecasts: weather.hourlyForecasts,
        dailyForecasts: weather.dailyForecasts,
      );
    });
    return _weather;
  }

  @override
  Widget build(BuildContext context) {
     
    final ThemeData theme = Theme.of(context);
    Brightness brightness = theme.brightness;
    bool isMoonIcon = brightness == Brightness.dark ? true : false;
    return FutureBuilder<Weather>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the Future is complete, show the WeatherPage
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          // Handle error state
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          
          // Otherwise, show the WeatherPage
          return Scaffold(
            backgroundColor: theme.primaryColor,
            body: RefreshIndicator(
              onRefresh: () async {
                await _fetchWeather();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 50.0, bottom: 20.0),
                            child: Stack(
                              children: [
                                const Align(
                                  child: Text(
                                    "uWeather",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0),
                                  ),
                                ),
                                Positioned(
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Toggle between moon and sun icon
                                        isMoonIcon = !isMoonIcon;
                                        _currentThemeMode =
                                            brightness == Brightness.light
                                                ? ThemeMode.dark
                                                : ThemeMode.light;
                                        widget.onThemeModeChanged(
                                            _currentThemeMode);
                                      });
                                    },
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                          milliseconds:
                                              300), // Adjust duration as needed
                                      child: isMoonIcon
                                          ? SvgPicture.asset(
                                              "assets/moon.svg",
                                              key: const ValueKey(
                                                  'moon'), // Use ValueKey for the moon icon
                                              height: 30.0,
                                              width: 30.0,
                                            )
                                          : SvgPicture.asset(
                                              "assets/sun.svg",
                                              key: const ValueKey(
                                                  'sun'), // Use ValueKey for the sun icon
                                              height: 30.0,
                                              width: 30.0,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      BlendMode.srcIn),
                                            ),
                                      // Apply a fade transition
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                          // City name
                          Text(
                            _weather.city,
                            style: const TextStyle(
                              fontSize: 36.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30),
                          // Temperature
                          const Text("A l'instant"),
                          Text(
                            '${_weather.temperature.round()}°C',
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Image.asset(
                            conditionIcons[_weather.code] ??
                                'assets/default_icon.png',
                          ),
                          const SizedBox(height: 2),
                          // // Weather condition
                          Text(
                            _weather.conditionText,
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding:  EdgeInsets.only(left: 12.0),
                          child:  Text(
                            "Previsions horaires",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        HourlyForecastList(
                            hourlyForecasts: _weather.hourlyForecasts,
                            conditionIcons: conditionIcons),
                        const SizedBox(
                          height: 30,
                        ),
                        const Padding(
                          padding:  EdgeInsets.only(left: 8.0),
                          child:  Text(
                            "Previsions journalieres",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w800),
                          ),
                        ),
                        DailyForecastList(
                          dailyForecasts: _weather.dailyForecasts,
                          conditionIcons: conditionIcons,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'weather_model.dart'; // Import your Weather model and other dependencies

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> dailyForecasts;
  final Map<int, String> conditionIcons;

  const DailyForecastList({super.key, 
    required this.dailyForecasts,
    required this.conditionIcons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500, // Adjust the height as needed
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: dailyForecasts.map((forecast) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    forecast.date,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    conditionIcons[forecast.code] ?? 'assets/default_icon.png',
                    width: 50, // Adjust the width as needed
                    height: 50, // Adjust the height as needed
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        forecast.conditionText,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                          '${forecast.maxTemperature.round()}°C / ${forecast.minTemperature.round()}°C'),
                      // Text(
                      //     'Chance of rain: ${forecast.chanceOfRain}%'),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'weather_model.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast> hourlyForecasts;
  final Map<int, String> conditionIcons;

  const HourlyForecastList({
    Key? key,
    required this.hourlyForecasts,
    required this.conditionIcons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, // Adjust the height as needed
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 234, 234, 234),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: hourlyForecasts.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final forecast = hourlyForecasts[index];
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Text('${DateTime.parse(forecast.time).hour}:00', style:const TextStyle(fontWeight: FontWeight.bold)),
                    // Text(forecast.conditionText),
                    Image.asset(
                      conditionIcons[forecast.code] ??
                          'assets/default_icon.png',
                    ),
                    Text('${forecast.temperature.round()}°C'),
                    Text('${forecast.chanceOfRain.toInt().toString()}%', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

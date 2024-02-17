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
    final ThemeData theme = Theme.of(context);
    Color boxColor;

    if (theme.brightness == Brightness.light) {
      // Use a lighter color when the theme is light
      boxColor = Colors.white; // You can adjust this color as needed
    } else {
      // Use a darker color when the theme is dark
      boxColor = const Color.fromARGB(255, 10, 15, 32); // You can adjust this color as needed
    }
    return SizedBox(
      height: 140, // Adjust the height as needed
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: boxColor,
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
              print(DateTime.parse(forecast.time));
              print(DateTime.now());
              String formattedTime =
                  (DateTime.parse(forecast.time).hour == DateTime.now().hour)
                      ? 'Now' 
                      : '${DateTime.parse(forecast.time).hour}:00';

              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Text(formattedTime,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Image.asset(
                      conditionIcons[forecast.code] ??
                          'assets/default_icon.png',
                    ),
                    Text('${forecast.temperature.round()}°C'),
                    Text('${forecast.chanceOfRain.toInt().toString()}%',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold)),
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

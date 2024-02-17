import 'package:flutter/material.dart';
import 'weather_model.dart'; // Import your Weather model and other dependencies

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> dailyForecasts;
  final Map<int, String> conditionIcons;

  const DailyForecastList({
    super.key,
    required this.dailyForecasts,
    required this.conditionIcons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Adjust the height as needed
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: dailyForecasts.map((forecast) {
            return Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          _getDayOfWeek(forecast.date),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        conditionIcons[forecast.code] ??
                            'assets/default_icon.png',
                        width: 50, // Adjust the width as needed
                        height: 50, // Adjust the height as needed
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

String _getDayOfWeek(String date) {
  DateTime dateTime = DateTime.parse(date);
  DateTime today = DateTime.now();
  if (dateTime.year == today.year &&
      dateTime.month == today.month &&
      dateTime.day == today.day) {
    return 'Today';
  } else {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

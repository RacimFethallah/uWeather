// class Weather {
//   final String city;
//   // final double latitude;
//   // final double longitude;
//   final double temperature;
//   final String mainCondition;

//   Weather(
//       {required this.city,
//       // required this.latitude,
//       // required this.longitude,
//       required this.temperature,
//       required this.mainCondition});

//   factory Weather.fromJson(Map<String, dynamic> json) {
//     return Weather(
//       city: json['name'] ?? '',
//       // latitude: json['coord'] != null ? (json['coord']['lat'] as num).toDouble() : 0.0,
//       // longitude: json['coord'] != null ? (json['coord']['lon'] as num).toDouble() : 0.0,
//       temperature:
//           json['main'] != null ? (json['main']['temp'] as num).toDouble() : 0.0,
//       mainCondition: json['weather'] != null && json['weather'].isNotEmpty
//           ? json['weather'][0]['main'].toString()
//           : '',
//     );
//   }
// }

class Weather {
  final String city;
  // final double latitude;
  // final double longitude;
  final double temperature;
  final String conditionText;
  final int code;
  final List<HourlyForecast> hourlyForecasts;
  final List<DailyForecast> dailyForecasts;

  Weather(
      {required this.city,
      // required this.latitude,
      // required this.longitude,
      required this.temperature,
      required this.conditionText,
      required this.code,
      required this.hourlyForecasts,
      required this.dailyForecasts});

  factory Weather.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    final currentDay = now.day;
    final currentHour = now.hour;

    // Extract hourly data directly in a single step
    final hourlyData = (json['forecast']['forecastday'] as List)
        .expand((day) => day['hour'] as List)
        .toList();

    final hourlyForecasts = hourlyData
        .where((forecast) {
          final forecastDateTime = DateTime.parse(forecast['time']);
          final forecastDay = forecastDateTime.day;
          final forecastHour = forecastDateTime.hour;

          return (forecastDay == currentDay && forecastHour >= currentHour) ||
              (forecastDay == currentDay + 1 && forecastHour < currentHour);
        })
        .map((forecast) => HourlyForecast.fromJson(forecast))
        .toList();

    return Weather(
      city: '',
      // latitude: json['coord'] != null ? (json['coord']['lat'] as num).toDouble() : 0.0,
      // longitude: json['coord'] != null ? (json['coord']['lon'] as num).toDouble() : 0.0,
      temperature: (json['current']['temp_c'] as num).toDouble(),
      conditionText: (json['current']['condition']['text'] as String),
      code: (json['current']['condition']['code'] as num).toInt(),
      // Parse HourlyForecast list if needed
      hourlyForecasts: hourlyForecasts,
      // Parse DailyForecast list if needed
      dailyForecasts: (json['forecast']['forecastday'] as List)
          .map((forecast) => DailyForecast.fromJson(forecast))
          .toList(),
    );
  }
}

class HourlyForecast {
  final String time;
  final double temperature;
  final String conditionText;
  final int code;
  final double chanceOfRain;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.conditionText,
    required this.code,
    required this.chanceOfRain,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'],
      temperature: (json['temp_c'] as num).toDouble(),
      conditionText: (json['condition']['text'] as String),
      code: (json['condition']['code'] as num).toInt(),
      chanceOfRain: (json['chance_of_rain'] as num).toDouble(),
    );
  }
}

class DailyForecast {
  final String date;
  final double maxTemperature;
  final double minTemperature;
  final String conditionText;
  final int code;

  DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.conditionText,
    required this.code,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date'],
      maxTemperature: (json['day']['maxtemp_c'] as num).toDouble(),
      minTemperature: (json['day']['mintemp_c'] as num).toDouble(),
      conditionText: (json['day']['condition']['text'] as String),
      code: (json['day']['condition']['code'] as num).toInt(),
    );
  }
}

class Weather {
  final String city;
  // final double latitude;
  // final double longitude;
  final double temperature;
  final String mainCondition;

  Weather(
      {required this.city,
      // required this.latitude,
      // required this.longitude,
      required this.temperature,
      required this.mainCondition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? '',
      // latitude: json['coord'] != null ? (json['coord']['lat'] as num).toDouble() : 0.0,
      // longitude: json['coord'] != null ? (json['coord']['lon'] as num).toDouble() : 0.0,
      temperature:
          json['main'] != null ? (json['main']['temp'] as num).toDouble() : 0.0,
      mainCondition: json['weather'] != null && json['weather'].isNotEmpty
          ? json['weather'][0]['main'].toString()
          : '',
    );
  }
}

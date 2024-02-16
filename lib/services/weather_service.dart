import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;

  WeatherService({required this.apiKey});

  //method to get weather
  Future<Weather> getWeather(double lat, double lon) async {
    try {
      //final response = await http.get(Uri.parse('$BASE_URL?q=$city&appid=$apiKey&units=metric'));
      final response = await http.get(
          Uri.parse('$BASE_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Failed to load weather: $e');
    }
  }

  //method to get current city
  Future<Map<String, dynamic>> getCurrentCity() async {
    // request location from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    // fetch current location if request is granted
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert location into a list of placemark object
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract city name from placemark
    String? city = placemarks[0].locality;
    double latitude = position.latitude;
    double longitude = position.longitude;

    Map<String, dynamic> cityData = {
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    };

    return cityData;
  }
}

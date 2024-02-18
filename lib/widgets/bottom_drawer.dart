import 'package:flutter/material.dart';

class BottomDrawer extends StatelessWidget {
  final String selectedProvider;
  final void Function(String) onProviderChanged;

  const BottomDrawer({super.key, 
    required this.selectedProvider,
    required this.onProviderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            const Text(
              'Select a provider',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Divider(),
            RadioListTile<String>(
              title: const Text('WeatherApi.com'),
              value: 'weatherapi',
              groupValue: selectedProvider,
              onChanged: (value) {
                onProviderChanged(value!);
              },
            ),
            RadioListTile<String>(
              title: const Text('OpenWeatherMap.org'),
              value: 'openweathermap',
              groupValue: selectedProvider,
              onChanged: (value) {
                onProviderChanged(value!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

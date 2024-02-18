import 'package:flutter/material.dart';

import 'pages/weather_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _currentThemeMode = ThemeMode.system;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: _currentThemeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 255, 251, 235),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor:const Color.fromARGB(255, 17, 28, 57),
      ),
      debugShowCheckedModeBanner: false,
      home: WeatherPage(
        onThemeModeChanged: (themeMode) {
          setState(() {
            _currentThemeMode = themeMode;
          });
        },
      ),
    );
  }
}

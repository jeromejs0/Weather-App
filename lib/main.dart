import 'package:flutter/material.dart'; //add packages: flutter pub add pacakagename
import 'package:weather_app_v2/pages/weather_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(fontFamily: 'ffgoodpro'),
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

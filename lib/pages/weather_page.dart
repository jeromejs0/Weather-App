import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_v2/models/weather_model.dart';
import 'package:weather_app_v2/services/weather_service.dart';
import 'city_search_delegate.dart'; // Import the search delegate

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('f786200a4c80c2bf5ec2fe8f89754f87');
  Weather? _weather;
  String _currentCity = 'New York'; // Default city
  String? _currentCondition = 'clear'; // Default condition

  // Fetch weather for the given city
  Future<void> _fetchWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _currentCity = cityName; // Update the current city
        _currentCondition = weather.mainCondition; // Update the condition
      });
    } catch (e) {
      print("Error fetching weather: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to fetch weather for the selected city.')),
      );
    }
  }

  // Fetch weather for the user's current location
  Future<void> _fetchCurrentLocationWeather() async {
    try {
      final cityName = await _weatherService.getCurrentCity();
      await _fetchWeather(cityName);
    } catch (e) {
      print("Error fetching current location weather: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to fetch location-based weather.')),
      );
    }
  }

  // Background color based on weather condition
  Color getBackgroundColor(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
      case 'fog':
        return const Color(0xFFC9DAF0); // Cloudy/Fog
      case 'rain':
      case 'drizzle':
        return const Color(0xFF9F40FF); // Rain/Drizzle
      case 'thunderstorm':
        return const Color(0xFF5A45CF); // Thunderstorm
      case 'clear':
        return const Color(0xFFF6E027); // Clear
      default:
        return const Color(0xFF69ADF1); // Default (e.g., sunny)
    }
  }

  // Determine text color (black or white) based on brightness
  Color getTextColor(String? mainCondition) {
    final bgColor = getBackgroundColor(mainCondition);
    final brightness = ThemeData.estimateBrightnessForColor(bgColor);
    return brightness == Brightness.light ? Colors.black : Colors.white;
  }

  // Weather animation assets
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/null_cond.json'; // Default animation

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
        return 'assets/heavy_rain.json';
      case 'drizzle':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(_currentCity); // Fetch weather for the default city
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = getBackgroundColor(_currentCondition);
    final textColor = getTextColor(_currentCondition);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Weather in $_currentCity',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: textColor,
            onPressed: () async {
              // Show the search bar and fetch weather for the entered city
              final cityName = await showSearch(
                context: context,
                delegate: CitySearchDelegate(),
              );
              if (cityName != null && cityName.isNotEmpty) {
                _fetchWeather(cityName);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            color: textColor,
            onPressed: _fetchCurrentLocationWeather, // Fetch weather for current location
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather?.cityName ?? "Loading city...",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Lottie.asset(
              getWeatherAnimation(_currentCondition),
              height: 150,
            ),
            Text(
              _weather?.mainCondition ?? "",
              style: TextStyle(
                fontSize: 20,
                color: textColor,
              ),
            ),
            Text(
              '${_weather?.temperature.round()}°C',
              style: TextStyle(
                fontSize: 25,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

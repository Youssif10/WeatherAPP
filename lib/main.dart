import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather_model.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final TextEditingController _controller = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;
  WeatherService _weatherService = WeatherService();

  void _fetchWeather() async {
    setState(() {
      _isLoading = true;  // Set loading to true
    });

    try {
      Weather weather = await _weatherService.fetchWeather(_controller.text);
      setState(() {
        _weather = weather;  // Update the weather object
      });
    } catch (e) {
      print('Error fetching weather: $e');  // Log the error to the console
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load weather data. Please check the city name or try again later.')),
      );
    }

    setState(() {
      _isLoading = false;  // Stop loading once the request is done
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pexels-pixabay-158827.jpg'), // Make sure to add your image here
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Foreground Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 50), // Space for the AppBar
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter city',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchWeather,
                    child: const Text('Get Weather'),
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : _weather != null
                          ? Column(
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(seconds: 1),
                                  style: const TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                                  child: Text('City: ${_weather!.cityName}'),
                                ),
                                const SizedBox(height: 8),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(seconds: 1),
                                  style: const TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                                  child: Text('Temperature: ${_weather!.temperature}°C'),
                                ),
                                const SizedBox(height: 8),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(seconds: 1),
                                  style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                                  child: Text('Description: ${_weather!.description}'),
                                ),
                              ],
                            )
                          : const Text(
                              'Enter a city name and press "Get Weather"',
                              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        appBar: AppBar(
          title: const Text('Weather App')
          ,backgroundColor: const Color.fromARGB(255, 0, 191, 255),
          
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter city',
                  border: OutlineInputBorder(),
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
                            Text(
                              'City: ${_weather!.cityName}',
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Temperature: ${_weather!.temperature}°C',
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Description: ${_weather!.description}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      : const Text('Enter a city name and press "Get Weather"'),
            ],
          ),
        ),
      ),
    );
  }
}



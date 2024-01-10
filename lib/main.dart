import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Radar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: WeatherRadarScreen(),
    );
  }
}

class WeatherRadarScreen extends StatefulWidget {
  @override
  _WeatherRadarScreenState createState() => _WeatherRadarScreenState();
}

class _WeatherRadarScreenState extends State<WeatherRadarScreen> {
  final TextEditingController _locationController = TextEditingController();
  Map<String, dynamic> _weatherData = {};
  bool _isDarkMode = false;

  Future<Map<String, dynamic>> getWeather(String location) async {
    final apiKey = 'a8cc9dd1f6175c27121091365e2e7bd9';
    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to load weather data. Status code: ${response.statusCode}');
      throw Exception('Failed to load weather data');
    }
  }

  void _updateWeather() async {
    final location = _locationController.text;
    if (location.isNotEmpty) {
      try {
        final weatherData = await getWeather(location);

        setState(() {
          _weatherData = weatherData;
        });
      } catch (e) {
        print('Error fetching weather data: $e');
        setState(() {
          _weatherData = {'error': 'Error fetching weather data'};
        });
      }
    } else {
      setState(() {
        _weatherData = {'error': 'Please enter a location'};
      });
    }
  }

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  String formatTemperature(double temperature) {
    return '${temperature.toStringAsFixed(0)} °C';
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Radar App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather Radar'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Tampilkan menu pengaturan saat ikon ditekan
                showSettingsMenu(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Radar Cuaca',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Enter City or Country',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateWeather,
                child: Text('Cek Cuaca'),
              ),
              SizedBox(height: 20),
              if (_weatherData.containsKey('error'))
                Text(
                  _weatherData['error'],
                  style: TextStyle(fontSize: 18, color: Colors.red),
                )
              else if (_weatherData.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Temperature: ${formatTemperature(kelvinToCelsius(_weatherData['main']['temp']))}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Description: ${_weatherData['weather'][0]['description']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'City: ${_weatherData['name']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.nightlight_round),
                title: Text('Dark Mode'),
                onTap: () {
                  _toggleDarkMode();
                  Navigator.pop(context);
                },
              ),
              // Tambahkan opsi pengaturan lainnya sesuai kebutuhan
            ],
          ),
        );
      },
    );
  }
}

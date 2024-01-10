import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uascuaca/weather.dart';

class DataService {
  Future<Weather> fetchData(String cityName) async {
    final queryParams = {
      'q': cityName,
      'appid': 'a8cc9dd1f6175c27121091365e2e7bd9',
      'units': 'imperial'
    };

    final uri = Uri.http("api.openweathermap.org", "/data/2.5/weather", queryParams);
    
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

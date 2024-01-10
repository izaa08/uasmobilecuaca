class Weather {
  final String name;
  final String description;
  final String icon;
  final double Temp;

  Weather({this.name = '', this.description = '', this.icon = '', this.Temp = 0});



  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather (
      name: json['name'] ?? '',
      description: json['weather'][0]['description'],
      icon: json ['weather'][0]['icon'],
      Temp: json ['main']['temp']);
  }
}
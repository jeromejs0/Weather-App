class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityName,//req -> must be provided while creating instance
    required this.temperature,
    required this.mainCondition,
  });

  //to decode the api
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],//accessing the main prop of the first element
    );
  }
}

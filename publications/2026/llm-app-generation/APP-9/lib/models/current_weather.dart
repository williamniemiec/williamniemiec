class CurrentWeather {
  final double temp;
  final double feelsLike;
  final String description;
  final double windSpeed;
  final int humidity;

  CurrentWeather({
    required this.temp,
    required this.feelsLike,
    required this.description,
    required this.windSpeed,
    required this.humidity,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
    );
  }
}
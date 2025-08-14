class HourlyForecast {
  final DateTime time;
  final double temp;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.icon,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: json['main']['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}
class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String icon;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.icon,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMax: json['temp']['max'].toDouble(),
      tempMin: json['temp']['min'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}
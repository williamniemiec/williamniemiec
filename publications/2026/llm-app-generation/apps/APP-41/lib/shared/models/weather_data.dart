class WeatherData {
  final CurrentWeather current;
  final List<HourlyForecast> hourlyForecast;
  final List<DailyForecast> dailyForecast;
  final WeatherMetrics metrics;
  final List<WeatherAlert> alerts;
  final DateTime lastUpdated;

  const WeatherData({
    required this.current,
    required this.hourlyForecast,
    required this.dailyForecast,
    required this.metrics,
    required this.alerts,
    required this.lastUpdated,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: CurrentWeather.fromJson(json['current'] ?? {}),
      hourlyForecast: (json['hourly'] as List<dynamic>?)
          ?.map((item) => HourlyForecast.fromJson(item))
          .toList() ?? [],
      dailyForecast: (json['daily'] as List<dynamic>?)
          ?.map((item) => DailyForecast.fromJson(item))
          .toList() ?? [],
      metrics: WeatherMetrics.fromJson(json['metrics'] ?? {}),
      alerts: (json['alerts'] as List<dynamic>?)
          ?.map((item) => WeatherAlert.fromJson(item))
          .toList() ?? [],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'hourly': hourlyForecast.map((item) => item.toJson()).toList(),
      'daily': dailyForecast.map((item) => item.toJson()).toList(),
      'metrics': metrics.toJson(),
      'alerts': alerts.map((item) => item.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final String condition;
  final String description;
  final String iconCode;
  final double humidity;
  final double windSpeed;
  final int windDirection;
  final double pressure;
  final double visibility;
  final int uvIndex;
  final DateTime timestamp;

  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.timestamp,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temp'] ?? json['temperature'] ?? 0.0).toDouble(),
      feelsLike: (json['feels_like'] ?? json['feelsLike'] ?? 0.0).toDouble(),
      condition: json['condition'] ?? '',
      description: json['description'] ?? '',
      iconCode: json['icon'] ?? json['iconCode'] ?? '',
      humidity: (json['humidity'] ?? 0.0).toDouble(),
      windSpeed: (json['wind_speed'] ?? json['windSpeed'] ?? 0.0).toDouble(),
      windDirection: (json['wind_deg'] ?? json['windDirection'] ?? 0).toInt(),
      pressure: (json['pressure'] ?? 0.0).toDouble(),
      visibility: (json['visibility'] ?? 0.0).toDouble(),
      uvIndex: (json['uv'] ?? json['uvIndex'] ?? 0).toInt(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feelsLike': feelsLike,
      'condition': condition,
      'description': description,
      'iconCode': iconCode,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'pressure': pressure,
      'visibility': visibility,
      'uvIndex': uvIndex,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String condition;
  final String iconCode;
  final double precipitationProbability;
  final double windSpeed;
  final int windDirection;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.iconCode,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.windDirection,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.parse(json['time'] ?? json['dt_txt'] ?? DateTime.now().toIso8601String()),
      temperature: (json['temp'] ?? json['temperature'] ?? 0.0).toDouble(),
      condition: json['condition'] ?? '',
      iconCode: json['icon'] ?? json['iconCode'] ?? '',
      precipitationProbability: (json['pop'] ?? json['precipitationProbability'] ?? 0.0).toDouble(),
      windSpeed: (json['wind_speed'] ?? json['windSpeed'] ?? 0.0).toDouble(),
      windDirection: (json['wind_deg'] ?? json['windDirection'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'temperature': temperature,
      'condition': condition,
      'iconCode': iconCode,
      'precipitationProbability': precipitationProbability,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
    };
  }
}

class DailyForecast {
  final DateTime date;
  final double highTemperature;
  final double lowTemperature;
  final String condition;
  final String description;
  final String iconCode;
  final double precipitationProbability;
  final double windSpeed;
  final int windDirection;
  final int uvIndex;
  final DateTime sunrise;
  final DateTime sunset;

  const DailyForecast({
    required this.date,
    required this.highTemperature,
    required this.lowTemperature,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.parse(json['date'] ?? json['dt'] ?? DateTime.now().toIso8601String()),
      highTemperature: (json['temp']?['max'] ?? json['highTemperature'] ?? 0.0).toDouble(),
      lowTemperature: (json['temp']?['min'] ?? json['lowTemperature'] ?? 0.0).toDouble(),
      condition: json['weather']?[0]?['main'] ?? json['condition'] ?? '',
      description: json['weather']?[0]?['description'] ?? json['description'] ?? '',
      iconCode: json['weather']?[0]?['icon'] ?? json['iconCode'] ?? '',
      precipitationProbability: (json['pop'] ?? json['precipitationProbability'] ?? 0.0).toDouble(),
      windSpeed: (json['wind_speed'] ?? json['windSpeed'] ?? 0.0).toDouble(),
      windDirection: (json['wind_deg'] ?? json['windDirection'] ?? 0).toInt(),
      uvIndex: (json['uvi'] ?? json['uvIndex'] ?? 0).toInt(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sunrise'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sunset'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'highTemperature': highTemperature,
      'lowTemperature': lowTemperature,
      'condition': condition,
      'description': description,
      'iconCode': iconCode,
      'precipitationProbability': precipitationProbability,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'uvIndex': uvIndex,
      'sunrise': sunrise.toIso8601String(),
      'sunset': sunset.toIso8601String(),
    };
  }
}

class WeatherMetrics {
  final double dewPoint;
  final int airQualityIndex;
  final String airQualityDescription;
  final int pollenCount;
  final String pollenDescription;
  final String moonPhase;
  final double moonIllumination;

  const WeatherMetrics({
    required this.dewPoint,
    required this.airQualityIndex,
    required this.airQualityDescription,
    required this.pollenCount,
    required this.pollenDescription,
    required this.moonPhase,
    required this.moonIllumination,
  });

  factory WeatherMetrics.fromJson(Map<String, dynamic> json) {
    return WeatherMetrics(
      dewPoint: (json['dew_point'] ?? json['dewPoint'] ?? 0.0).toDouble(),
      airQualityIndex: (json['aqi'] ?? json['airQualityIndex'] ?? 0).toInt(),
      airQualityDescription: json['air_quality_description'] ?? json['airQualityDescription'] ?? '',
      pollenCount: (json['pollen_count'] ?? json['pollenCount'] ?? 0).toInt(),
      pollenDescription: json['pollen_description'] ?? json['pollenDescription'] ?? '',
      moonPhase: json['moon_phase'] ?? json['moonPhase'] ?? '',
      moonIllumination: (json['moon_illumination'] ?? json['moonIllumination'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dewPoint': dewPoint,
      'airQualityIndex': airQualityIndex,
      'airQualityDescription': airQualityDescription,
      'pollenCount': pollenCount,
      'pollenDescription': pollenDescription,
      'moonPhase': moonPhase,
      'moonIllumination': moonIllumination,
    };
  }
}

class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String type;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> areas;

  const WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.areas,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['event'] ?? '',
      description: json['description'] ?? '',
      severity: json['severity'] ?? '',
      type: json['type'] ?? json['event'] ?? '',
      startTime: DateTime.parse(json['start'] ?? json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['end'] ?? json['endTime'] ?? DateTime.now().toIso8601String()),
      areas: (json['areas'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity,
      'type': type,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'areas': areas,
    };
  }
}
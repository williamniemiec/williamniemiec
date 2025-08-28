import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final List<WeatherAlert> alerts;
  final Location location;

  const WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
    required this.alerts,
    required this.location,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}

@JsonSerializable()
class CurrentWeather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double pressure;
  final double windSpeed;
  final int windDirection;
  final double visibility;
  final double dewPoint;
  final int uvIndex;
  final String condition;
  final String description;
  final String icon;
  final DateTime timestamp;
  final double precipitationProbability;
  final double precipitationAmount;

  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.visibility,
    required this.dewPoint,
    required this.uvIndex,
    required this.condition,
    required this.description,
    required this.icon,
    required this.timestamp,
    required this.precipitationProbability,
    required this.precipitationAmount,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentWeatherToJson(this);
}

@JsonSerializable()
class HourlyForecast {
  final DateTime time;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int windDirection;
  final String condition;
  final String icon;
  final double precipitationProbability;
  final double precipitationAmount;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.condition,
    required this.icon,
    required this.precipitationProbability,
    required this.precipitationAmount,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) =>
      _$HourlyForecastFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyForecastToJson(this);
}

@JsonSerializable()
class DailyForecast {
  final DateTime date;
  final double highTemperature;
  final double lowTemperature;
  final int humidity;
  final double windSpeed;
  final int windDirection;
  final String condition;
  final String description;
  final String icon;
  final double precipitationProbability;
  final double precipitationAmount;
  final DateTime sunrise;
  final DateTime sunset;
  final int uvIndex;

  const DailyForecast({
    required this.date,
    required this.highTemperature,
    required this.lowTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.condition,
    required this.description,
    required this.icon,
    required this.precipitationProbability,
    required this.precipitationAmount,
    required this.sunrise,
    required this.sunset,
    required this.uvIndex,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastFromJson(json);

  Map<String, dynamic> toJson() => _$DailyForecastToJson(this);
}

@JsonSerializable()
class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String urgency;
  final String certainty;
  final DateTime effective;
  final DateTime expires;
  final String senderName;
  final List<String> areas;
  final String event;
  final String headline;
  final String instruction;

  const WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.urgency,
    required this.certainty,
    required this.effective,
    required this.expires,
    required this.senderName,
    required this.areas,
    required this.event,
    required this.headline,
    required this.instruction,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) =>
      _$WeatherAlertFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherAlertToJson(this);

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(effective) && now.isBefore(expires);
  }

  bool get isSevere {
    return severity.toLowerCase() == 'severe' || 
           severity.toLowerCase() == 'extreme';
  }
}

@JsonSerializable()
class Location {
  final String name;
  final String state;
  final String country;
  final double latitude;
  final double longitude;
  final String timezone;
  final int timezoneOffset;

  const Location({
    required this.name,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.timezoneOffset,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  String get displayName {
    if (state.isNotEmpty) {
      return '$name, $state';
    }
    return '$name, $country';
  }
}

@JsonSerializable()
class RadarData {
  final String imageUrl;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final int zoom;
  final String type; // 'precipitation', 'satellite', 'temperature'
  final Map<String, dynamic> metadata;

  const RadarData({
    required this.imageUrl,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.zoom,
    required this.type,
    required this.metadata,
  });

  factory RadarData.fromJson(Map<String, dynamic> json) =>
      _$RadarDataFromJson(json);

  Map<String, dynamic> toJson() => _$RadarDataToJson(this);
}

@JsonSerializable()
class RadarFrame {
  final String imageUrl;
  final DateTime timestamp;
  final double intensity;

  const RadarFrame({
    required this.imageUrl,
    required this.timestamp,
    required this.intensity,
  });

  factory RadarFrame.fromJson(Map<String, dynamic> json) =>
      _$RadarFrameFromJson(json);

  Map<String, dynamic> toJson() => _$RadarFrameToJson(this);
}

@JsonSerializable()
class SavedLocation {
  final String id;
  final Location location;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SavedLocation({
    required this.id,
    required this.location,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SavedLocation.fromJson(Map<String, dynamic> json) =>
      _$SavedLocationFromJson(json);

  Map<String, dynamic> toJson() => _$SavedLocationToJson(this);
}
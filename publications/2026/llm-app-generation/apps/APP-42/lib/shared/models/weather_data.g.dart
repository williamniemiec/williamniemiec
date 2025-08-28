// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => WeatherAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'current': instance.current,
      'hourly': instance.hourly,
      'daily': instance.daily,
      'alerts': instance.alerts,
      'location': instance.location,
    };

CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    CurrentWeather(
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      pressure: (json['pressure'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toInt(),
      visibility: (json['visibility'] as num).toDouble(),
      dewPoint: (json['dewPoint'] as num).toDouble(),
      uvIndex: (json['uvIndex'] as num).toInt(),
      condition: json['condition'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      precipitationProbability:
          (json['precipitationProbability'] as num).toDouble(),
      precipitationAmount: (json['precipitationAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$CurrentWeatherToJson(CurrentWeather instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'visibility': instance.visibility,
      'dewPoint': instance.dewPoint,
      'uvIndex': instance.uvIndex,
      'condition': instance.condition,
      'description': instance.description,
      'icon': instance.icon,
      'timestamp': instance.timestamp.toIso8601String(),
      'precipitationProbability': instance.precipitationProbability,
      'precipitationAmount': instance.precipitationAmount,
    };

HourlyForecast _$HourlyForecastFromJson(Map<String, dynamic> json) =>
    HourlyForecast(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toInt(),
      condition: json['condition'] as String,
      icon: json['icon'] as String,
      precipitationProbability:
          (json['precipitationProbability'] as num).toDouble(),
      precipitationAmount: (json['precipitationAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$HourlyForecastToJson(HourlyForecast instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperature': instance.temperature,
      'feelsLike': instance.feelsLike,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'condition': instance.condition,
      'icon': instance.icon,
      'precipitationProbability': instance.precipitationProbability,
      'precipitationAmount': instance.precipitationAmount,
    };

DailyForecast _$DailyForecastFromJson(Map<String, dynamic> json) =>
    DailyForecast(
      date: DateTime.parse(json['date'] as String),
      highTemperature: (json['highTemperature'] as num).toDouble(),
      lowTemperature: (json['lowTemperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toInt(),
      condition: json['condition'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      precipitationProbability:
          (json['precipitationProbability'] as num).toDouble(),
      precipitationAmount: (json['precipitationAmount'] as num).toDouble(),
      sunrise: DateTime.parse(json['sunrise'] as String),
      sunset: DateTime.parse(json['sunset'] as String),
      uvIndex: (json['uvIndex'] as num).toInt(),
    );

Map<String, dynamic> _$DailyForecastToJson(DailyForecast instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'highTemperature': instance.highTemperature,
      'lowTemperature': instance.lowTemperature,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'condition': instance.condition,
      'description': instance.description,
      'icon': instance.icon,
      'precipitationProbability': instance.precipitationProbability,
      'precipitationAmount': instance.precipitationAmount,
      'sunrise': instance.sunrise.toIso8601String(),
      'sunset': instance.sunset.toIso8601String(),
      'uvIndex': instance.uvIndex,
    };

WeatherAlert _$WeatherAlertFromJson(Map<String, dynamic> json) => WeatherAlert(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      urgency: json['urgency'] as String,
      certainty: json['certainty'] as String,
      effective: DateTime.parse(json['effective'] as String),
      expires: DateTime.parse(json['expires'] as String),
      senderName: json['senderName'] as String,
      areas: (json['areas'] as List<dynamic>).map((e) => e as String).toList(),
      event: json['event'] as String,
      headline: json['headline'] as String,
      instruction: json['instruction'] as String,
    );

Map<String, dynamic> _$WeatherAlertToJson(WeatherAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'severity': instance.severity,
      'urgency': instance.urgency,
      'certainty': instance.certainty,
      'effective': instance.effective.toIso8601String(),
      'expires': instance.expires.toIso8601String(),
      'senderName': instance.senderName,
      'areas': instance.areas,
      'event': instance.event,
      'headline': instance.headline,
      'instruction': instance.instruction,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      name: json['name'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String,
      timezoneOffset: (json['timezoneOffset'] as num).toInt(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'name': instance.name,
      'state': instance.state,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timezone': instance.timezone,
      'timezoneOffset': instance.timezoneOffset,
    };

RadarData _$RadarDataFromJson(Map<String, dynamic> json) => RadarData(
      imageUrl: json['imageUrl'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      zoom: (json['zoom'] as num).toInt(),
      type: json['type'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$RadarDataToJson(RadarData instance) => <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'timestamp': instance.timestamp.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'zoom': instance.zoom,
      'type': instance.type,
      'metadata': instance.metadata,
    };

RadarFrame _$RadarFrameFromJson(Map<String, dynamic> json) => RadarFrame(
      imageUrl: json['imageUrl'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      intensity: (json['intensity'] as num).toDouble(),
    );

Map<String, dynamic> _$RadarFrameToJson(RadarFrame instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'timestamp': instance.timestamp.toIso8601String(),
      'intensity': instance.intensity,
    };

SavedLocation _$SavedLocationFromJson(Map<String, dynamic> json) =>
    SavedLocation(
      id: json['id'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      isDefault: json['isDefault'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SavedLocationToJson(SavedLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

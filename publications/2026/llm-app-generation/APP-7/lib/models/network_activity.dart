import 'package:equatable/equatable.dart';

class NetworkActivity extends Equatable {
  final String appName;
  final String domain;
  final bool isBlocked;
  final DateTime timestamp;

  const NetworkActivity({
    required this.appName,
    required this.domain,
    required this.isBlocked,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [appName, domain, isBlocked, timestamp];
}
import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool isFirewallEnabled;
  final Set<String> blockedAppsWifi;
  final Set<String> blockedAppsCellular;

  const AppSettings({
    required this.isFirewallEnabled,
    required this.blockedAppsWifi,
    required this.blockedAppsCellular,
  });

  @override
  List<Object?> get props => [
        isFirewallEnabled,
        blockedAppsWifi,
        blockedAppsCellular,
      ];
}
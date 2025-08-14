import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class FirewallScreen extends StatefulWidget {
  const FirewallScreen({super.key});

  @override
  _FirewallScreenState createState() => _FirewallScreenState();
}

class _FirewallScreenState extends State<FirewallScreen> {
  List<Application> _apps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
    setState(() {
      _apps = apps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firewall'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _apps.length,
              itemBuilder: (context, index) {
                final app = _apps[index];
                return ListTile(
                  leading: app is ApplicationWithIcon
                      ? Image.memory(app.icon)
                      : const Icon(Icons.apps),
                  title: Text(app.appName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi),
                      Switch(
                        value: true, // Dummy value
                        onChanged: (value) {},
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.network_cell),
                      Switch(
                        value: true, // Dummy value
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
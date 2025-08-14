import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_browser/models/settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Privacy & Security'),
          ),
          SwitchListTile(
            title: const Text('Block Trackers & Ads'),
            value: true, // TODO: Implement this setting
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Anti-Fingerprinting'),
            value: true, // TODO: Implement this setting
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Enable JavaScript'),
            value: settingsModel.javaScriptEnabled,
            onChanged: (value) {
              settingsModel.setJavaScriptEnabled(value);
            },
          ),
          SwitchListTile(
            title: const Text('Enable Tor Mode'),
            value: settingsModel.torEnabled,
            onChanged: (value) {
              settingsModel.setTorEnabled(value);
            },
          ),
        ],
      ),
    );
  }
}
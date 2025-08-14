import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_browser/models/browser_model.dart';

void showShieldMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      final browserModel = Provider.of<BrowserModel>(context);
      final activeTab = browserModel.activeTab;

      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${browserModel.contentBlockers.length} trackers & ads blocked on this site.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Protection Enabled'),
              value: browserModel.contentBlockers.isNotEmpty,
              onChanged: (value) {
                // TODO: Implement toggle protection
              },
            ),
          ],
        ),
      );
    },
  );
}
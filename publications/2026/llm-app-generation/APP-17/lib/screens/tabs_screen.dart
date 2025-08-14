import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_browser/models/browser_model.dart';
import 'package:sentinel_browser/models/tab_model.dart';

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final browserModel = Provider.of<BrowserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              browserModel.addTab();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: browserModel.tabs.length,
        itemBuilder: (context, index) {
          final tab = browserModel.tabs[index];
          return ListTile(
            title: Text(tab.url?.toString() ?? 'New Tab'),
            onTap: () {
              browserModel.setActiveTab(tab.id);
              Navigator.pop(context);
            },
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                browserModel.removeTab(tab.id);
              },
            ),
          );
        },
      ),
    );
  }
}
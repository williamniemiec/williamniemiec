import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_browser/models/browser_model.dart';
import 'package:sentinel_browser/models/settings_model.dart';
import 'package:sentinel_browser/screens/settings_screen.dart';
import 'package:sentinel_browser/screens/tabs_screen.dart';
import 'package:sentinel_browser/services/content_blocker.dart';
import 'package:sentinel_browser/services/https_upgrader.dart';
import 'package:sentinel_browser/widgets/shield_menu.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  @override
  Widget build(BuildContext context) {
    final browserModel = Provider.of<BrowserModel>(context);
    final settingsModel = Provider.of<SettingsModel>(context);
    final activeTab = browserModel.activeTab;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (activeTab != null && activeTab.progress < 1.0)
              LinearProgressIndicator(value: activeTab.progress),
            Expanded(
              child: Stack(
                children: browserModel.tabs.map((tab) {
                  return Offstage(
                    offstage: tab.id != activeTab?.id,
                    child: InAppWebView(
                      key: tab.webViewKey,
                      initialUrlRequest: URLRequest(
                        url: WebUri("https://www.google.com"),
                      ),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          contentBlockers: AdAndTrackerBlocker.blockers,
                          javaScriptEnabled: settingsModel.javaScriptEnabled,
                          userAgent:
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
                        ),
                      ),
                      onWebViewCreated: (controller) {
                        tab.webViewController = controller;
                      },
                      shouldInterceptRequest: (controller, request) async {
                        if (request.url.scheme == 'http') {
                          final httpsUri = request.url.replace(scheme: 'https');
                          await controller.loadUrl(
                              urlRequest: URLRequest(url: WebUri.uri(httpsUri)));
                          return null;
                        }
                        return null;
                      },
                      onLoadStart: (controller, url) {
                        browserModel.setUrl(url);
                      },
                      onProgressChanged: (controller, progress) {
                        browserModel.setProgress(progress / 100);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextField(
                  onSubmitted: (url) {
                    browserModel.loadUrl(url);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search or type URL',
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.shield_outlined),
                      onPressed: () {
                        showShieldMenu(context);
                      },
                    ),
                    suffixIcon: settingsModel.torEnabled
                        ? const Icon(Icons.vpn_lock_outlined)
                        : null,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_none),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TabsScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.local_fire_department_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Forget All Tabs and Data?'),
                      content: const Text('This cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            browserModel.clearAll();
                            Navigator.pop(context);
                          },
                          child: const Text('Forget'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sentinel_browser/models/tab_model.dart';
import 'dart:math';

class BrowserModel extends ChangeNotifier {
  List<TabModel> _tabs = [];
  int _activeTabId = 0;
  List<ContentBlocker> _contentBlockers = [];

  List<TabModel> get tabs => _tabs;
  TabModel? get activeTab =>
      _tabs.isNotEmpty ? _tabs.firstWhere((tab) => tab.id == _activeTabId) : null;
  List<ContentBlocker> get contentBlockers => _contentBlockers;

  BrowserModel() {
    addTab();
  }

  void addTab() {
    final newId = Random().nextInt(10000);
    _tabs.add(TabModel(id: newId, webViewKey: GlobalKey()));
    _activeTabId = newId;
    notifyListeners();
  }

  void setActiveTab(int id) {
    _activeTabId = id;
    notifyListeners();
  }

  void removeTab(int id) {
    _tabs.removeWhere((tab) => tab.id == id);
    if (_tabs.isNotEmpty) {
      _activeTabId = _tabs.first.id;
    } else {
      addTab();
    }
    notifyListeners();
  }

  void setContentBlockers(List<ContentBlocker> blockers) {
    _contentBlockers = blockers;
    activeTab?.webViewController?.setOptions(
        options: InAppWebViewGroupOptions(
            crossPlatform:
                InAppWebViewOptions(contentBlockers: _contentBlockers)));
    notifyListeners();
  }

  void setUrl(Uri? url) {
    activeTab?.url = url;
    notifyListeners();
  }

  void setProgress(double progress) {
    activeTab?.progress = progress;
    notifyListeners();
  }

  void loadUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && activeTab != null) {
      activeTab!.webViewController
          ?.loadUrl(urlRequest: URLRequest(url: WebUri.uri(uri)));
    }
  }

  void goBack() {
    activeTab?.webViewController?.goBack();
  }

  void goForward() {
    activeTab?.webViewController?.goForward();
  }

  void reload() {
    activeTab?.webViewController?.reload();
  }

  void clearAll() {
    _tabs.clear();
    addTab();
    notifyListeners();
  }
}
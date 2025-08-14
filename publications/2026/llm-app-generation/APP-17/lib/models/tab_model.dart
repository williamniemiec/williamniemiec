import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TabModel {
  final int id;
  final GlobalKey<State<InAppWebView>> webViewKey;
  InAppWebViewController? webViewController;
  Uri? url;
  double progress = 0;

  TabModel({
    required this.id,
    required this.webViewKey,
    this.webViewController,
    this.url,
  });
}
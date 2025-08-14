import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HttpsUpgrader extends WebViewAssetLoader {
  @override
  Future<WebResourceResponse?> handle(WebResourceRequest request) async {
    if (request.url.scheme == 'http') {
      final httpsUri = request.url.replace(scheme: 'https');
      return WebResourceResponse(
        contentType: '',
        data: null,
        headers: {'Location': httpsUri.toString()},
        statusCode: 307,
        reasonPhrase: 'Temporary Redirect',
      );
    }
    return null;
  }
}
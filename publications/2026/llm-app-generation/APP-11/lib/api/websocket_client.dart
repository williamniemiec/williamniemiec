import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  late WebSocketChannel channel;

  void connect(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void disconnect() {
    channel.sink.close();
  }
}
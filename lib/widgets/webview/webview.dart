import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noimann_academy/widgets/webview/webview_windows.dart';

class WebViewWidget extends StatefulWidget {
  const WebViewWidget({
    super.key,
    required this.baseProtocol,
    required this.baseHost,
    required this.onLoadingChanged,
  });
  final String baseProtocol;
  final String baseHost;
  final ValueChanged<bool> onLoadingChanged;

  @override
  WebViewWidgetState createState() => WebViewWidgetState();
}

class WebViewWidgetState extends State<WebViewWidget> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return WebviewWindows(
        baseProtocol: widget.baseProtocol,
        baseHost: widget.baseHost,
        onLoadingChanged: widget.onLoadingChanged,
      );
    }
    // Placeholder for other platforms
    return const Center(child: Text('Platform not supported yet'));
  }
}

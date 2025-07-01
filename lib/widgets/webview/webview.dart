import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noimann_academy/widgets/webview/webview_mobile_macos.dart';
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

    if (Platform.isAndroid || Platform.isMacOS || Platform.isIOS) {
      return WebviewMobile(
        baseProtocol: widget.baseProtocol,
        baseHost: widget.baseHost,
        onLoadingChanged: widget.onLoadingChanged,
      );
    }

    return const Center(child: Text('Платформа ещё не поддерживается'));
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewMobile extends StatefulWidget {
  const WebviewMobile({
    super.key,
    required this.baseProtocol,
    required this.baseHost,
    required this.onLoadingChanged,
  });
  final String baseProtocol;
  final String baseHost;
  final ValueChanged<bool> onLoadingChanged;

  @override
  WebviewMobileState createState() => WebviewMobileState();
}

class WebviewMobileState extends State<WebviewMobile> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                widget.onLoadingChanged(true);
              },
              onPageFinished: (url) {
                widget.onLoadingChanged(false);
              },
              onWebResourceError: (error) {
                widget.onLoadingChanged(false);
              },
              onNavigationRequest: (request) {
                final uri = Uri.parse(request.url);
                if (uri.host == widget.baseHost ||
                    uri.host.endsWith('.${widget.baseHost}')) {
                  return NavigationDecision.navigate;
                }
                _controller.loadRequest(
                  Uri.parse('${widget.baseProtocol}${widget.baseHost}'),
                );
                return NavigationDecision.prevent;
              },
            ),
          )
          ..loadRequest(Uri.parse('${widget.baseProtocol}${widget.baseHost}'));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }

  @override
  void dispose() {
    // No explicit disposal needed for WebViewController
    super.dispose();
  }
}

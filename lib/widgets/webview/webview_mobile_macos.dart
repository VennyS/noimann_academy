import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewMobile extends StatefulWidget {
  const WebviewMobile({
    super.key,
    required this.baseProtocol,
    required this.baseHost,
    required this.onLoadingChanged,
    required this.onError,
  });
  final String baseProtocol;
  final String baseHost;
  final ValueChanged<bool> onLoadingChanged;
  final ValueChanged<bool> onError;

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
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                widget.onError(false);
                widget.onLoadingChanged(true);
              },
              onPageFinished: (url) {
                widget.onLoadingChanged(false);
              },
              onWebResourceError: (error) {
                widget.onLoadingChanged(false);
                widget.onError(true);
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

  void goBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
    }
  }

  void reload() {
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

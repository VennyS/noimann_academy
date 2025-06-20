import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class WebviewWindows extends StatefulWidget {
  const WebviewWindows({
    super.key,
    required this.baseProtocol,
    required this.baseHost,
    required this.onLoadingChanged,
  });
  final String baseProtocol;
  final String baseHost;
  final ValueChanged<bool> onLoadingChanged;

  @override
  WebviewWindowsState createState() => WebviewWindowsState();
}

class WebviewWindowsState extends State<WebviewWindows> {
  final _controller = WebviewController();
  late String _currentUrl;

  @override
  void initState() {
    super.initState();
    _currentUrl = '${widget.baseProtocol}${widget.baseHost}';
    _initWebView();
  }

  Future<void> _initWebView() async {
    try {
      await _controller.initialize();
      // Listen for URL changes
      _controller.url.listen((url) {
        setState(() {
          _currentUrl = url;
        });
        // Restrict navigation
        if (!_isUrlAllowed(url)) {
          _controller.loadUrl('${widget.baseProtocol}${widget.baseHost}');
        }
      });

      // Listen for loading state
      _controller.loadingState.listen((state) {
        final isLoading = state == LoadingState.loading;
        widget.onLoadingChanged(isLoading);
      });

      // Load initial URL
      await _controller.loadUrl(_currentUrl);
    } catch (e) {
      print('Error initializing WebView: $e');
    }
  }

  bool _isUrlAllowed(String url) {
    final uri = Uri.parse(url);
    return uri.host == widget.baseHost ||
        uri.host.endsWith('.${widget.baseHost}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Webview(
      _controller,
      permissionRequested: (permission, resource, frame) {
        return WebviewPermissionDecision.allow;
      },
    );
  }
}

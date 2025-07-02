import 'package:flutter/material.dart';
import 'package:noimann_academy/lib/check_site_is_reacheble.dart';
import 'package:webview_windows/webview_windows.dart';

class WebviewWindows extends StatefulWidget {
  const WebviewWindows({
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
      final isReachable = await checkSiteIsReachable(_currentUrl);

      widget.onError(!isReachable);
      if (!isReachable) return;

      _controller.url.listen((url) {
        setState(() {
          _currentUrl = url;
        });

        if (!_isUrlAllowed(url)) {
          _controller.loadUrl('${widget.baseProtocol}${widget.baseHost}');
        }
      });

      _controller.loadingState.listen((state) {
        final isLoading = state == LoadingState.loading;
        widget.onLoadingChanged(isLoading);
      });

      await _controller.loadUrl(_currentUrl);
    } catch (e) {
      widget.onError(true);
    }
  }

  bool _isUrlAllowed(String url) {
    final uri = Uri.parse(url);
    return uri.host == widget.baseHost ||
        uri.host.endsWith('.${widget.baseHost}');
  }

  void reload() {
    _controller.reload();
  }

  void goBack() {
    _controller.goBack();
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

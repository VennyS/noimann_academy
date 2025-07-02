import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:noimann_academy/constants.dart';
import 'package:noimann_academy/widgets/floating_bar/floating_bar.dart';
import 'package:noimann_academy/widgets/no_internet/no_internet.dart';
import 'package:noimann_academy/widgets/splash_screen/splash_screen.dart';
import 'package:noimann_academy/widgets/webview/webview.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noimann Academy',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final GlobalKey<WebViewWidgetState> _webViewKey =
      GlobalKey<WebViewWidgetState>();

  bool _isWebViewLoading = true;
  bool _hasInternet = true;
  bool _hasLoadingError = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkInternet();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      setState(() {
        _hasInternet =
            results.isNotEmpty &&
            results.any((result) => result != ConnectivityResult.none);
      });
    });
  }

  Future<void> _checkInternet() async {
    final results = await Connectivity().checkConnectivity();
    setState(() {
      _hasInternet =
          results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none);
    });
  }

  void _goBack() {
    _webViewKey.currentState?.goBack();
  }

  void _refresh() {
    _webViewKey.currentState?.reload();
  }

  void onLoadingChanged(bool isLoading) {
    setState(() {
      _isWebViewLoading = isLoading;
    });
  }

  void onError(bool isError) {
    setState(() {
      _hasLoadingError = isError;
    });
  }

  FloatingBar? buildFloatingbar() {
    if (_hasInternet && !_isWebViewLoading && !_hasLoadingError) return null;

    return FloatingBar(onGoBack: _goBack, onRefresh: _refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (_hasInternet && !_hasLoadingError)
                    WebViewWidget(
                      key: _webViewKey,
                      baseProtocol: baseProtocol,
                      baseHost: baseHost,
                      onLoadingChanged: onLoadingChanged,
                      onError: onError,
                    )
                  else
                    const NoInternetWidget(),
                  if (_hasInternet && _isWebViewLoading) SplashScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: buildFloatingbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

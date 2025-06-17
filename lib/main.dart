import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:noimann_academy/constants.dart';
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
      title: 'WebView App',
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
  bool _isWebViewLoading = true;
  bool _hasInternet = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkInternet();
    // Listen for connectivity changes
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

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_hasInternet)
            WebViewWidget(
              baseProtocol: baseProtocol,
              baseHost: baseHost,
              onLoadingChanged: (isLoading) {
                setState(() {
                  _isWebViewLoading = isLoading;
                });
              },
            )
          else
            const NoInternetWidget(),
          if (_hasInternet && _isWebViewLoading) SplashScreen(),
        ],
      ),
    );
  }
}

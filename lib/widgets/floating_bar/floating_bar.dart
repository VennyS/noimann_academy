import 'package:flutter/material.dart';

class FloatingBar extends StatelessWidget {
  final VoidCallback onGoBack;
  final VoidCallback onRefresh;

  const FloatingBar({
    super.key,
    required this.onGoBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: onGoBack, icon: Icon(Icons.arrow_back)),
          IconButton(onPressed: onRefresh, icon: Icon(Icons.refresh)),
        ],
      ),
    );
  }
}

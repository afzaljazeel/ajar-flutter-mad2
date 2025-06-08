import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOffline) return const SizedBox.shrink();

    return Container(
      color: Colors.red,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Center(
        child: Text(
          "You're in offline mode",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

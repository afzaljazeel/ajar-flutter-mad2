import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusWidget extends StatefulWidget {
  const NetworkStatusWidget({super.key});

  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isConnected
        ? const SizedBox.shrink()
        : Container(
            width: double.infinity,
            color: Colors.red,
            padding: const EdgeInsets.all(8),
            child: const Text(
              '⚠️ No internet connection',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
  }
}

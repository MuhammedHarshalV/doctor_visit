import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkService {
  static StreamSubscription? _subscription;

  static void startListening() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      bool hasInternet = !result.contains(ConnectivityResult.none);

      if (!hasInternet) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: const Text(
              'No Internet Connection',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            duration: const Duration(days: 1),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 70, // adjust based on bottom nav height
            ),
          ),
        );
      
      } else {
        scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

        // scaffoldMessengerKey.currentState?.showSnackBar(
        //   SnackBar(
        //     content: const Text(
        //       'Internet Connected',
        //       style: TextStyle(fontWeight: FontWeight.bold),
        //     ),
        //     duration: const Duration(seconds: 2),
        //     backgroundColor: Colors.green,
        //     behavior: SnackBarBehavior.floating,
        //     margin: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
        //   ),
        // );
      }
    });
  }

  static void dispose() {
    _subscription?.cancel();
  }
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

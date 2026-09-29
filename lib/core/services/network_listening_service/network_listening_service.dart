import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class NetworkService {
  static StreamSubscription<List<ConnectivityResult>>?
  _connectivitySubscription;

  static StreamSubscription<ServiceStatus>? _locationSubscription;

  static bool _hasInternet = true;
  static bool _locationEnabled = true;

  static Future<void> startListening() async {
    _listenInternet();

    await _listenLocation();
  }

  // ============================================================
  // INTERNET LISTENER
  // ============================================================

  static void _listenInternet() {
    _connectivitySubscription?.cancel();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      _hasInternet = !result.contains(ConnectivityResult.none);

      debugPrint('INTERNET: $_hasInternet');

      _showCurrentMessage();
    });
  }

  // ============================================================
  // LOCATION LISTENER
  // ============================================================

  static Future<void> _listenLocation() async {
    // Initial location check
    _locationEnabled = await Geolocator.isLocationServiceEnabled();

    debugPrint('LOCATION INITIAL: $_locationEnabled');

    // Show message if location is already OFF
    _showCurrentMessage();

    await _locationSubscription?.cancel();

    _locationSubscription = Geolocator.getServiceStatusStream().listen(
      (ServiceStatus status) {
        _locationEnabled = status == ServiceStatus.enabled;

        debugPrint('LOCATION STATUS: $_locationEnabled');

        _showCurrentMessage();
      },
      onError: (error) {
        debugPrint('LOCATION LISTENER ERROR: $error');
      },
    );
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  static void _showCurrentMessage() {
    final messenger = scaffoldMessengerKey.currentState;

    if (messenger == null) {
      // MaterialApp may not be ready yet
      Future.delayed(const Duration(milliseconds: 500), _showCurrentMessage);

      return;
    }

    messenger.hideCurrentSnackBar();

    // ------------------------------------------
    // LOCATION OFF
    // ------------------------------------------

    if (!_locationEnabled) {
      messenger.showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.location_off, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please turn on Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          duration: Duration(days: 1),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 70),
        ),
      );

      return;
    }

    // ------------------------------------------
    // INTERNET OFF
    // ------------------------------------------

    if (!_hasInternet) {
      messenger.showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'No Internet Connection',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          duration: Duration(days: 1),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 70),
        ),
      );

      return;
    }

    // Both internet + location are OK
    messenger.hideCurrentSnackBar();
  }

  // ============================================================
  // MANUAL LOCATION CHECK
  // ============================================================

  static Future<void> checkLocation() async {
    _locationEnabled = await Geolocator.isLocationServiceEnabled();

    debugPrint('LOCATION MANUAL: $_locationEnabled');

    _showCurrentMessage();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  static Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _locationSubscription?.cancel();

    _connectivitySubscription = null;
    _locationSubscription = null;
  }
}

class LocationOffScreen extends StatelessWidget {
  const LocationOffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(
                        alpha: 0.08,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_off_rounded,
                      size: 52,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Location is Turned Off',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Please turn on your device location to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
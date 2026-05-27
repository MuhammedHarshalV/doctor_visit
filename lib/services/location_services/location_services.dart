import 'dart:developer';
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  // Step 1: Check if location service is enabled
  final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'Location services are disabled. Please enable GPS.';
    
  }

  // Step 2: Check permission status
  LocationPermission permission = await Geolocator.checkPermission();

  // Step 3: Request if denied
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permission denied.';
    }
  }

  // Step 4: Handle permanently denied
  if (permission == LocationPermission.deniedForever) {
    throw 'Location permission permanently denied. Please enable it from settings.';
  }

  // Step 5: Get and return current position
  log('Getting current location...');
  final Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  log('Location fetched: ${position.latitude}, ${position.longitude}');
  return position;
}

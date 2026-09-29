import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:doctor_visit/core/routes/app_routes.dart';
import 'package:doctor_visit/core/services/network_listening_service/network_listening_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Temporary SSL certificate workaround
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await NetworkService.startListening();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: router,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          log('SSL HOST: $host');
          log('SSL PORT: $port');

          return true;
        };

    return client;
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:gps_camera_snap/gps_camera_snap.dart';

// // Get your free API key from https://www.maptiler.com/
// const String mapTilerApiKey = String.fromEnvironment('MAPTILER_API_KEY');

// // Optional: Google Maps API key from https://console.cloud.google.com/
// const String googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

// // Set to true to use Google Maps instead of MapTiler
// const bool useGoogleMaps = bool.fromEnvironment('USE_GOOGLE_MAPS');

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Determine which provider to use
//   final mapProvider = useGoogleMaps
//       ? MapProvider.googleMaps
//       : MapProvider.mapTiler;

//   // Validate the appropriate API key (but don't exit on failure)
//   if (mapProvider == MapProvider.googleMaps) {
//     if (googleMapsApiKey.isNotEmpty) {
//       final isValid = await MapTilerValidator.validateGoogleMaps(
//         googleMapsApiKey,
//       );
//       MapTilerValidator.logValidationResult(
//         isValid,
//         googleMapsApiKey,
//         provider: MapProvider.googleMaps,
//       );
//     } else {
//       // ignore: avoid_print
//       print(
//         '⚠️  No Google Maps API key provided. Map will show lat/lng fallback.',
//       );
//       // ignore: avoid_print
//       print(
//         '   Run with: flutter run --dart-define=GOOGLE_MAPS_API_KEY=YOUR_KEY --dart-define=USE_GOOGLE_MAPS=true',
//       );
//     }
//   } else {
//     if (mapTilerApiKey.isNotEmpty) {
//       final isValid = await MapTilerValidator.validate(mapTilerApiKey);
//       MapTilerValidator.logValidationResult(isValid, mapTilerApiKey);
//     } else {
//       // ignore: avoid_print
//       print(
//         '⚠️  No MapTiler API key provided. Map will show lat/lng fallback.',
//       );
//       // ignore: avoid_print
//       print('   Run with: flutter run --dart-define=MAPTILER_API_KEY=YOUR_KEY');
//     }
//   }

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'GPS Camera Example',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'GPS Camera Demo'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String? _capturedPath;

//   Future<void> _openCamera() async {
//     // Check whether GPS/location service is enabled
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();

//     if (!serviceEnabled) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enable location service')),
//       );
//       return;
//     }

//     // Check permission
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.denied) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location permission is required')),
//       );
//       return;
//     }

//     if (permission == LocationPermission.deniedForever) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Location permission is permanently denied'),
//           action: SnackBarAction(
//             label: 'Settings',
//             onPressed: () {
//               Geolocator.openAppSettings();
//             },
//           ),
//         ),
//       );

//       return;
//     }

//     if (!mounted) return;

//     final mapProvider = useGoogleMaps
//         ? MapProvider.googleMaps
//         : MapProvider.mapTiler;

//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => GpsCamera(
//           config: GpsCameraConfig(
//             mapTilerApiKey: mapTilerApiKey,
//             mapProvider: mapProvider,
//             googleMapsApiKey: googleMapsApiKey.isNotEmpty
//                 ? googleMapsApiKey
//                 : null,
//             showMap: false,
//             showAddress: true,
//             showCoordinates: true,
//             showDate: true,
//             showTime: true,
//           ),
//           onImageCaptured: (path) {
//             Navigator.of(context).pop();

//             if (!mounted) return;

//             setState(() {
//               _capturedPath = path;
//             });
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_capturedPath != null) ...[
//               const Text(
//                 'Captured Image:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 height: 400,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: Image.file(File(_capturedPath!)),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 _capturedPath!,
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             ] else
//               const Text('No image captured yet.'),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _openCamera,
//         tooltip: 'Open Camera',
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }

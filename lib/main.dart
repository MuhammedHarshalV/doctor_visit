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
  NetworkService.startListening();

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

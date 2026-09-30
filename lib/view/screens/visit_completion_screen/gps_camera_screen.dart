import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// =====================================================
// GPS CAMERA
// =====================================================

class GpsCameraScreen extends StatefulWidget {
  final bool isSelfie;
  const GpsCameraScreen({super.key, required this.isSelfie});

  @override
  State<GpsCameraScreen> createState() => _GpsCameraScreenState();
}

class _GpsCameraScreenState extends State<GpsCameraScreen> {
  CameraController? _cameraController;

  List<CameraDescription> _cameras = [];

  Position? _position;

  String _address = 'Getting location...';

  bool _cameraLoading = true;
  bool _capturing = false;

  // ===================================================
  // INIT
  // ===================================================

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Get location
    await _getLocation();

    // FRONT CAMERA DEFAULT
    await _initializeCamera(
      widget.isSelfie ? CameraLensDirection.front : CameraLensDirection.back,
    );
  }

  // ===================================================
  // LOCATION
  // ===================================================

  Future<void> _getLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _address = 'Location service disabled';
        });

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _address = 'Location permission denied';
        });

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _address = 'Location permission permanently denied';
        });

        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      String finalAddress = '';

      try {
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final Placemark place = placemarks.first;

          final List<String?> addressParts = [
            place.name,
            place.street,
            place.subLocality,
            place.locality,
            place.subAdministrativeArea,
            place.administrativeArea,
            place.postalCode,
          ];

          finalAddress = addressParts
              .where((value) => value != null && value.trim().isNotEmpty)
              .map((value) => value!.trim())
              .toSet()
              .join(', ');
        }
      } catch (e) {
        debugPrint('Address error: $e');
      }

      if (!mounted) return;

      setState(() {
        _position = position;

        _address = finalAddress.isNotEmpty ? finalAddress : 'Location found';
      });
    } catch (e) {
      debugPrint('Location error: $e');

      if (!mounted) return;

      setState(() {
        _address = 'Unable to get location';
      });
    }
  }

  // ===================================================
  // CAMERA INITIALIZATION
  // ===================================================

  Future<void> _initializeCamera(CameraLensDirection direction) async {
    try {
      if (mounted) {
        setState(() {
          _cameraLoading = true;
        });
      }

      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        throw Exception('No camera available');
      }

      CameraDescription selectedCamera;

      try {
        selectedCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == direction,
        );
      } catch (_) {
        selectedCamera = _cameras.first;
      }

      await _cameraController?.dispose();

      final CameraController controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _cameraController = controller;

      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _cameraLoading = false;
      });
    } catch (e) {
      debugPrint('Camera error: $e');

      if (!mounted) return;

      setState(() {
        _cameraLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Camera error: $e')));
    }
  }

  // ===================================================
  // SWITCH FRONT / BACK
  // ===================================================

  // ===================================================
  // CAPTURE
  // ===================================================

  Future<void> _captureImage() async {
    final CameraController? controller = _cameraController;

    if (controller == null || !controller.value.isInitialized || _capturing) {
      return;
    }

    try {
      setState(() {
        _capturing = true;
      });

      // Take original photo
      final XFile capturedFile = await controller.takePicture();

      // Permanently add GPS/date/time/address
      final File finalImage = await _addDetailsToImage(capturedFile.path);

      if (!mounted) return;

      Navigator.pop(context, finalImage);
    } catch (e) {
      debugPrint('Capture error: $e');

      if (!mounted) return;

      setState(() {
        _capturing = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
    }
  }

  // ===================================================
  // ADD DETAILS PERMANENTLY TO IMAGE
  // ===================================================

  Future<File> _addDetailsToImage(String imagePath) async {
    final Uint8List bytes = await File(imagePath).readAsBytes();

    final img.Image? decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      throw Exception('Unable to decode image');
    }

    // Correct orientation
    final img.Image image = img.bakeOrientation(decodedImage);

    final DateTime now = DateTime.now();

    final String date = DateFormat('dd-MMM-yyyy').format(now);

    final String time = DateFormat('hh:mm a').format(now);

    final String latitude = _position?.latitude.toStringAsFixed(6) ?? 'N/A';

    final String longitude = _position?.longitude.toStringAsFixed(6) ?? 'N/A';

    // -----------------------------------------------
    // SCALE VALUES BASED ON IMAGE
    // -----------------------------------------------

    final int padding = (image.width * 0.035).round();

    final int overlayHeight = (image.height * 0.20).round();

    final int overlayTop = image.height - overlayHeight;

    // -----------------------------------------------
    // BLACK TRANSPARENT AREA
    // -----------------------------------------------

    img.fillRect(
      image,
      x1: 0,
      y1: overlayTop,
      x2: image.width - 1,
      y2: image.height - 1,
      color: img.ColorRgba8(0, 0, 0, 190),
    );

    int y = overlayTop + padding;

    // -----------------------------------------------
    // ADDRESS
    // -----------------------------------------------

    final List<String> addressLines = _splitAddress(_address, 42);

    for (final String line in addressLines) {
      img.drawString(
        image,
        line,
        font: img.arial24,
        x: padding,
        y: y,
        color: img.ColorRgb8(255, 255, 255),
      );

      y += 32;
    }

    y += 10;

    // -----------------------------------------------
    // LATITUDE / LONGITUDE
    // -----------------------------------------------

    img.drawString(
      image,
      'Lat: $latitude',
      font: img.arial24,
      x: padding,
      y: y,
      color: img.ColorRgb8(255, 255, 255),
    );

    y += 32;

    img.drawString(
      image,
      'Lng: $longitude',
      font: img.arial24,
      x: padding,
      y: y,
      color: img.ColorRgb8(255, 255, 255),
    );

    y += 40;

    // -----------------------------------------------
    // DATE + TIME
    // -----------------------------------------------

    img.drawString(
      image,
      '$date   $time',
      font: img.arial24,
      x: padding,
      y: y,
      color: img.ColorRgb8(255, 255, 255),
    );

    // -----------------------------------------------
    // SAVE FINAL IMAGE
    // -----------------------------------------------

    final Directory directory = await getTemporaryDirectory();

    final String outputPath =
        '${directory.path}/gps_photo_'
        '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final File outputFile = File(outputPath);

    await outputFile.writeAsBytes(img.encodeJpg(image, quality: 92));

    return outputFile;
  }

  // ===================================================
  // SPLIT LONG ADDRESS
  // ===================================================

  List<String> _splitAddress(String text, int maxLength) {
    if (text.length <= maxLength) {
      return [text];
    }

    final List<String> words = text.split(' ');

    final List<String> lines = [];

    String currentLine = '';

    for (final String word in words) {
      final String newLine = currentLine.isEmpty ? word : '$currentLine $word';

      if (newLine.length > maxLength) {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
        }

        currentLine = word;
      } else {
        currentLine = newLine;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines.take(2).toList();
  }

  // ===================================================
  // DISPOSE
  // ===================================================

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // ===================================================
  // CAMERA SCREEN UI
  // ===================================================

  @override
  Widget build(BuildContext context) {
    final CameraController? controller = _cameraController;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // =========================================
            // CAMERA PREVIEW
            // =========================================
            if (!_cameraLoading &&
                controller != null &&
                controller.value.isInitialized)
              Center(child: CameraPreview(controller))
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // =========================================
            // TOP BUTTONS
            // =========================================
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // _circleButton(
                  //   icon: Icons.close,
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.appWhite,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),

            // =========================================
            // LOCATION OVERLAY
            // =========================================
            Positioned(
              left: 15,
              right: 15,
              bottom: widget.isSelfie ? 120 : 160,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ADDRESS
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),

                        const SizedBox(width: 7),

                        Expanded(
                          child: Text(
                            _address,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // COORDINATES
                    if (_position != null)
                      Text(
                        'Lat: '
                        '${_position!.latitude.toStringAsFixed(6)}   '
                        'Lng: '
                        '${_position!.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),

                    const SizedBox(height: 8),

                    // DATE TIME
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 16,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(width: 15),

                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 16,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          DateFormat('hh:mm a').format(DateTime.now()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // =========================================
            // CAPTURE BUTTON
            // =========================================
            Positioned(
              bottom: widget.isSelfie ? 25 : 80,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _capturing ? null : _captureImage,
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 5),
                    ),
                    child: _capturing
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 32,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:doctor_visit/core/theme/colors/appcolors.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// =====================================================
// GPS VIDEO CAMERA
// =====================================================

class GpsVideoCameraScreen extends StatefulWidget {
  final bool isSelfie;

  const GpsVideoCameraScreen({super.key, required this.isSelfie});

  @override
  State<GpsVideoCameraScreen> createState() => _GpsVideoCameraScreenState();
}

class _GpsVideoCameraScreenState extends State<GpsVideoCameraScreen> {
  CameraController? _cameraController;

  List<CameraDescription> _cameras = [];

  Position? _position;

  String _address = 'Getting location...';

  bool _cameraLoading = true;

  bool _isRecording = false;

  bool _processingVideo = false;

  Duration _recordDuration = Duration.zero;

  Timer? _recordTimer;

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    // Get GPS location
    await _getLocation();

    // Initialize requested camera
    await _initializeCamera(
      widget.isSelfie ? CameraLensDirection.front : CameraLensDirection.back,
    );
  }

  // =====================================================
  // LOCATION
  // =====================================================

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

  // =====================================================
  // CAMERA INITIALIZATION
  // =====================================================

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

        // IMPORTANT FOR VIDEO
        enableAudio: true,
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

  // =====================================================
  // START VIDEO RECORDING
  // =====================================================

  Future<void> _startVideoRecording() async {
    final CameraController? controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isRecording ||
        _processingVideo) {
      return;
    }

    try {
      await controller.startVideoRecording();

      if (!mounted) return;

      setState(() {
        _isRecording = true;
        _recordDuration = Duration.zero;
      });

      _recordTimer?.cancel();

      _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;

        setState(() {
          _recordDuration += const Duration(seconds: 1);
        });
        // AUTO STOP AFTER 10 SECONDS
        if (_recordDuration.inSeconds >= 10) {
          timer.cancel();
          _stopVideoRecording();
        }
      });
    } catch (e) {
      debugPrint('Start video recording error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to start recording: $e')));
    }
  }

  Future<File> _addDetailsToVideo(String videoPath) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();

      // Get actual font file
      final String fontPath = await _getFFmpegFontPath();

      final String safeFontPath = _escapeFFmpegFilterPath(fontPath);

      final String outputPath =
          '${tempDir.path}/gps_video_'
          '${DateTime.now().millisecondsSinceEpoch}.mp4';

      final DateTime now = DateTime.now();

      final String date = DateFormat('dd-MMM-yyyy').format(now);

      final String time = DateFormat('hh:mm a').format(now);

      final String latitude = _position?.latitude.toStringAsFixed(6) ?? 'N/A';

      final String longitude = _position?.longitude.toStringAsFixed(6) ?? 'N/A';

      final String address = _escapeFFmpegText(_address);

      final String filter =
          // ==========================================
          // BLACK TRANSPARENT BACKGROUND
          // ==========================================
          "drawbox="
          "x=20:"
          "y=ih-250:"
          "w=iw-40:"
          "h=220:"
          "color=black@0.65:"
          "t=fill,"
          // ==========================================
          // ADDRESS
          // ==========================================
          "drawtext="
          "fontfile='$safeFontPath':"
          "text='$address':"
          "fontcolor=white:"
          "fontsize=28:"
          "x=40:"
          "y=h-225:"
          "shadowcolor=black:"
          "shadowx=2:"
          "shadowy=2,"
          // ==========================================
          // LATITUDE
          // ==========================================
          "drawtext="
          "fontfile='$safeFontPath':"
          "text='Lat\\: $latitude':"
          "fontcolor=white:"
          "fontsize=25:"
          "x=40:"
          "y=h-175:"
          "shadowcolor=black:"
          "shadowx=2:"
          "shadowy=2,"
          // ==========================================
          // LONGITUDE
          // ==========================================
          "drawtext="
          "fontfile='$safeFontPath':"
          "text='Lng\\: $longitude':"
          "fontcolor=white:"
          "fontsize=25:"
          "x=40:"
          "y=h-140:"
          "shadowcolor=black:"
          "shadowx=2:"
          "shadowy=2,"
          // ==========================================
          // DATE
          // ==========================================
          "drawtext="
          "fontfile='$safeFontPath':"
          "text='${_escapeFFmpegText(date)}':"
          "fontcolor=white:"
          "fontsize=25:"
          "x=40:"
          "y=h-90:"
          "shadowcolor=black:"
          "shadowx=2:"
          "shadowy=2,"
          // ==========================================
          // TIME
          // ==========================================
          "drawtext="
          "fontfile='$safeFontPath':"
          "text='${_escapeFFmpegText(time)}':"
          "fontcolor=white:"
          "fontsize=25:"
          "x=220:"
          "y=h-90:"
          "shadowcolor=black:"
          "shadowx=2:"
          "shadowy=2";

      final String command =
          '-y '
          '-i "${_escapePath(videoPath)}" '
          '-vf "$filter" '
          '-c:v libx264 '
          '-preset ultrafast '
          '-crf 23 '
          '-c:a aac '
          '-b:a 128k '
          '-movflags +faststart '
          '"${_escapePath(outputPath)}"';

      debugPrint('FFmpeg command: $command');

      final session = await FFmpegKit.execute(command);

      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final File finalVideo = File(outputPath);

        if (await finalVideo.exists()) {
          debugPrint('Watermarked video: $outputPath');

          return finalVideo;
        }
      }

      final String? output = await session.getOutput();

      debugPrint('FFmpeg error: $output');

      throw Exception('Failed to create watermarked video');
    } catch (e) {
      debugPrint('Video watermark error: $e');

      rethrow;
    }
  }

  Future<String> _getFFmpegFontPath() async {
    final Directory tempDir = await getTemporaryDirectory();

    final File fontFile = File('${tempDir.path}/TenorSans.otf');

    if (!await fontFile.exists()) {
      final ByteData data = await rootBundle.load(
        'asset/fonts/TenorSans-Regular.ttf',
      );

      await fontFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    }

    return fontFile.path;
  }

  String _escapeFFmpegText(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll(':', '\\:')
        .replaceAll("'", "\\'")
        .replaceAll(',', '\\,')
        .replaceAll('%', '\\%')
        .replaceAll('\n', ' ');
  }

  String _escapeFFmpegFilterPath(String path) {
    return path
        .replaceAll('\\', '/')
        .replaceAll(':', '\\:')
        .replaceAll("'", "\\'");
  }

  String _escapePath(String path) {
    return path.replaceAll('"', '\\"');
  }
  // =====================================================
  // STOP VIDEO RECORDING
  // =====================================================

  Future<void> _stopVideoRecording() async {
    final CameraController? controller = _cameraController;

    if (controller == null || !_isRecording || _processingVideo) {
      return;
    }

    try {
      _recordTimer?.cancel();

      setState(() {
        _processingVideo = true;
      });

      final XFile video = await controller.stopVideoRecording();

      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _processingVideo = false;
      });

      // Add permanent watermark
      final File finalVideo = await _addDetailsToVideo(video.path);

      if (!mounted) return;

      setState(() {
        _processingVideo = false;
      });

      // Return WATERMARKED video
      Navigator.pop(context, finalVideo);
    } catch (e) {
      debugPrint('Stop video recording error: $e');

      if (!mounted) return;

      setState(() {
        _isRecording = false;
        _processingVideo = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to stop recording: $e')));
    }
  }

  // =====================================================
  // RECORDING TIME FORMAT
  // =====================================================

  String _formatDuration(Duration duration) {
    final String minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final String seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  // =====================================================
  // BACK BUTTON
  // =====================================================

  Future<void> _handleBack() async {
    if (_isRecording) {
      try {
        _recordTimer?.cancel();

        await _cameraController?.stopVideoRecording();
      } catch (e) {
        debugPrint('Stop recording on back error: $e');
      }
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    _recordTimer?.cancel();

    _cameraController?.dispose();

    super.dispose();
  }

  // =====================================================
  // CAMERA SCREEN UI
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final CameraController? controller = _cameraController;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // =================================================
            // CAMERA PREVIEW
            // =================================================
            if (!_cameraLoading &&
                controller != null &&
                controller.value.isInitialized)
              Center(child: CameraPreview(controller))
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // =================================================
            // BACK BUTTON
            // =================================================
            Positioned(
              top: 15,
              left: 15,
              child: IconButton(
                onPressed: _processingVideo ? null : _handleBack,
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.appWhite,
                  size: 40,
                ),
              ),
            ),

            // =================================================
            // RECORDING TIMER
            // =================================================
            if (_isRecording)
              Positioned(
                top: 25,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .65),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          '${_formatDuration(_recordDuration)} / 00:10',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // =================================================
            // LOCATION INFORMATION
            // =================================================
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
                    // =========================================
                    // ADDRESS
                    // =========================================
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

                    // =========================================
                    // LATITUDE / LONGITUDE
                    // =========================================
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

                    // =========================================
                    // DATE / TIME
                    // =========================================
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

            // =================================================
            // START / STOP RECORD BUTTON
            // =================================================
            Positioned(
              bottom: widget.isSelfie ? 25 : 70,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _processingVideo
                      ? null
                      : () {
                          if (_isRecording) {
                            _stopVideoRecording();
                          } else {
                            _startVideoRecording();
                          }
                        },
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: _processingVideo
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: _isRecording ? 30 : 60,
                              height: _isRecording ? 30 : 60,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: _isRecording
                                    ? BoxShape.rectangle
                                    : BoxShape.circle,
                                borderRadius: _isRecording
                                    ? BorderRadius.circular(6)
                                    : null,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),

            // =================================================
            // RECORDING TEXT
            // =================================================
            if (_isRecording)
              Positioned(
                bottom: widget.isSelfie ? 5 : 35,
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    'Recording',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

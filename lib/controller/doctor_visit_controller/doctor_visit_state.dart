import 'dart:typed_data';

import 'package:flutter/material.dart';

class DoctorVisitCompletion {
  final TextEditingController feedbackController;
  final TextEditingController placeController;

  final String base64toApi;
  final String imagePath;

  //final String fileImage;
  final bool isLoading;
  final bool isComplete;

  final TimeOfDay? startTime;
  final TimeOfDay? arrivedTime;

  final TimeOfDay? endTime;
  final TimeOfDay? postponedTime;
  final bool isGoing;
  final bool isCompleted;
  final String response;
  final String place;

  DoctorVisitCompletion({
    this.base64toApi = '',
    this.isLoading = false,
    this.isComplete = false,
    this.place = '',
    this.response = '',
    this.imagePath = '',
    Uint8List? base64Image,
    // this.fileImage = '',
    this.startTime,
    this.arrivedTime,
    this.endTime,
    this.postponedTime,
    this.isGoing = false,
    this.isCompleted = false,
    required this.feedbackController,
    required this.placeController,
  });

  DoctorVisitCompletion copyWith({
    String? base64toApi,
    TextEditingController? feedbackController,
    TextEditingController? placeController,

    // String? fileImage,
    bool? isLoading,
    bool? isComplete,
    String? place,
    Object? startTime = _marker,
    Object? endTime = _marker,
    Object? arrivedTime = _marker,
    String? imagePath,
    TimeOfDay? postponedTime,
    bool? isGoing,
    bool? isCompleted,
    String? response,
  }) {
    return DoctorVisitCompletion(
      base64toApi: base64toApi ?? this.base64toApi,
      feedbackController: feedbackController ?? this.feedbackController,

      // fileImage: fileImage ?? this.fileImage,
      startTime: startTime == _marker
          ? this.startTime
          : startTime as TimeOfDay?,
      endTime: endTime == _marker ? this.endTime : endTime as TimeOfDay?,
      arrivedTime: arrivedTime == _marker
          ? this.arrivedTime
          : arrivedTime as TimeOfDay?,
      place: place ?? this.place,
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      placeController: placeController ?? this.placeController,
      isComplete: isComplete ?? this.isComplete,
      postponedTime: postponedTime ?? this.postponedTime,
      isGoing: isGoing ?? this.isGoing,
      isCompleted: isCompleted ?? this.isCompleted,
      response: response ?? this.response,
    );
  }
}

const _marker = Object();

import 'dart:typed_data';

import 'package:flutter/material.dart';

class DoctorVisitCompletion {
  final TextEditingController feedbackController;
  final String base64toApi;
  final Uint8List base64Image;
  //final String fileImage;
  final bool isLoading;
  final bool isComplete;

  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final TimeOfDay? postponedTime;
  final bool isGoing;
  final bool isCompleted;
  final String response;

  DoctorVisitCompletion({
    this.base64toApi = '',
    this.isLoading = false,
    this.isComplete = false,

    this.response = '',
    Uint8List? base64Image,
   // this.fileImage = '',
    this.startTime,
    this.endTime,
    this.postponedTime,
    this.isGoing = false,
    this.isCompleted = false,
    required this.feedbackController,
  }) : base64Image = base64Image ?? Uint8List(0);

  DoctorVisitCompletion copyWith({
    String? base64toApi,
    TextEditingController? feedbackController,
    Uint8List? base64Image,
   // String? fileImage,
    bool? isLoading,
    bool? isComplete,

    Object? startTime = _marker,
    Object? endTime = _marker,
    TimeOfDay? postponedTime,
    bool? isGoing,
    bool? isCompleted,
    String? response,
  }) {
    return DoctorVisitCompletion(
      base64toApi: base64toApi ?? this.base64toApi,
      feedbackController: feedbackController ?? this.feedbackController,
      base64Image: base64Image ?? this.base64Image,
     // fileImage: fileImage ?? this.fileImage,
      startTime: startTime == _marker
          ? this.startTime
          : startTime as TimeOfDay?,
      endTime: endTime == _marker ? this.endTime : endTime as TimeOfDay?,
      isLoading: isLoading ?? this.isLoading,

      isComplete: isComplete ?? this.isComplete,
      postponedTime: postponedTime ?? this.postponedTime,
      isGoing: isGoing ?? this.isGoing,
      isCompleted: isCompleted ?? this.isCompleted,
      response: response ?? this.response,
    );
  }
}

const _marker = Object();

import 'package:flutter/material.dart';

class DoctorVisitCompletion {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final TimeOfDay? postponedTime;
  final bool isGoing;
  final bool isCompleted;

  DoctorVisitCompletion({
    this.startTime,
    this.endTime,
    this.postponedTime,
    this.isGoing = false,
    this.isCompleted = false,
  });

  DoctorVisitCompletion copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    TimeOfDay? postponedTime,
    bool? isGoing,
    bool? isCompleted,
  }) {
    return DoctorVisitCompletion(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      postponedTime: postponedTime ?? this.postponedTime,
      isGoing: isGoing ?? this.isGoing,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

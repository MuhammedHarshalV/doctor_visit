import 'package:doctor_visit/controller/doctor_visit_controller/doctor_visit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisitController extends StateNotifier<DoctorVisitCompletion> {
  VisitController() : super(DoctorVisitCompletion());

  void setStartTime(TimeOfDay time) {
    state = state.copyWith(startTime: time);
  }

  void setIsGoing(bool isGoing) {
    state = state.copyWith(isGoing: isGoing);
  }

  void setIsCompleted(bool isCompleted) {
    state = state.copyWith(isCompleted: isCompleted);
  }

  void setEndTime(TimeOfDay time) {
    state = state.copyWith(endTime: time);
  }

  void setPostponedTime(TimeOfDay time) {
    state = state.copyWith(postponedTime: time);
  }
}

final doctorVisitProvider =
    StateNotifierProvider<VisitController, DoctorVisitCompletion>(
      (ref) => VisitController(),
    );

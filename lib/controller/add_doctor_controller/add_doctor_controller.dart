

import 'dart:developer';

import 'package:doctor_visit/controller/add_doctor_controller/add_doctor_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDoctorsController extends StateNotifier<AddDoctorsState> {
  AddDoctorsController() : super(AddDoctorsState());
  @override
  void dispose() {
    log('add doctor controller disposed.');
    super.dispose();
  }

  void setIsSubmitted(bool isSubmitted) {
    state = state.copyWith(isSubmitted: isSubmitted);
  }
}

final addDoctorProvider =
    StateNotifierProvider.autoDispose<AddDoctorsController, AddDoctorsState>(
      (ref) => AddDoctorsController(),
    );

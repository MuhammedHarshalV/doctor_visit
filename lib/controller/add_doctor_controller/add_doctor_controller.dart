import 'package:doctor_visit/controller/add_doctor_controller/add_doctor_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDoctorsController extends StateNotifier<AddDoctorsState> {
  AddDoctorsController() : super(AddDoctorsState());

  void setIsSubmitted(bool isSubmitted) {
    state = state.copyWith(isSubmitted: isSubmitted);
  }
}

final addDoctorProvider =
    StateNotifierProvider<AddDoctorsController, AddDoctorsState>(
      (ref) => AddDoctorsController(),
    );

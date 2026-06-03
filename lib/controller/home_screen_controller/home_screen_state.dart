import 'package:doctor_visit/model/doctos_assign_get/doctors_assign_response_model.dart';
import 'package:doctor_visit/model/work_completion_and_start_duty/work_completion_and_start_duty_response_model.dart';

class HomeScreenState {
  final List<DrList> doctorsListAPI;
  final Data? workRetatedData;
  final bool isLoading;
  final bool isOn;
  HomeScreenState({
    this.doctorsListAPI = const [],
    this.workRetatedData,
    this.isLoading = false,
    this.isOn = false,
  });

  HomeScreenState copyWith({
    List<DrList>? doctorsListAPI,
    bool? isLoading,
    bool? isOn,
    Data? workRetatedData,
  }) {
    return HomeScreenState(
      doctorsListAPI: doctorsListAPI ?? this.doctorsListAPI,
      isOn: isOn ?? this.isOn,
      isLoading: isLoading ?? this.isLoading,
      workRetatedData: workRetatedData ?? this.workRetatedData,
    );
  }
}

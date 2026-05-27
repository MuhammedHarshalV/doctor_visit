import 'package:doctor_visit/model/doctor_model.dart';

class HomeScreenState {
  final int doctorCount;
  final bool isOn;
  final bool isGoing;
  final bool isStartGoing;
  final List<DoctorModel> doctorsList;

  HomeScreenState({
    required this.doctorCount,
    this.isOn = false,
    this.isGoing = false,
    this.doctorsList = const [],
    this.isStartGoing = false,
  });

  HomeScreenState copyWith({
    int? doctorCount,
    bool? isOn,
    bool? isGoing,
    List<DoctorModel>? doctorsList,
    bool? isStartGoing,
  }) {
    return HomeScreenState(
      doctorCount: doctorCount ?? this.doctorCount,
      isOn: isOn ?? this.isOn,
      isGoing: isGoing ?? this.isGoing,
      isStartGoing: isStartGoing ?? this.isStartGoing,

      doctorsList: doctorsList ?? this.doctorsList,
    );
  }
}

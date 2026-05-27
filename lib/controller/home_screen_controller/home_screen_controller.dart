import 'dart:developer';

import 'package:doctor_visit/controller/home_screen_controller/home_screen_state.dart';
import 'package:doctor_visit/model/doctor_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class HomeScreenNotifier extends StateNotifier<HomeScreenState> {
  HomeScreenNotifier()
    : super(
        HomeScreenState(
          doctorCount: 1,
          doctorsList: [
            DoctorModel(
              name: 'Dr. Rahul',
              speciality: 'ENT',
              phoneNumber: '9999999999',
              timing: '2 PM',
              status: 'Upcoming',
              isGoing: 'No',
              isReach: 'No',
            ),
          ],
        ),
      ) {
    iniatialCall();
  }
  Future<void> iniatialCall() async {
    await checkDatabaseStatus();
  }

  //  Open Box ──
  Future<Box> _openBox() async {
    if (Hive.isBoxOpen('DoctorList')) {
      return Hive.box('DoctorList');
    }
    return await Hive.openBox('DoctorList');
  }

  //  Read All
  Future<void> checkDatabaseStatus() async {
    try {
      final box = await _openBox();
      final List<DoctorModel> doctorsList = box.values.map((e) {
        final map = Map<String, dynamic>.from(e);
        return DoctorModel(
          name: map['name'] ?? '',
          speciality: map['speciality'] ?? '',
          phoneNumber: map['pnoneNumber'] ?? '',
          timing: map['timing'] ?? '',
          status: map['status'] ?? '',
          isGoing: map['isGo'] ?? '',
          isReach: map['isReach'] ?? '',
        );
      }).toList();
      log('All History of Doctorlist(Hive): $doctorsList');
      state = state.copyWith(doctorsList: doctorsList);
    } catch (e) {
      log('checkDatabaseStatus error(Hive): $e');
    }
  }

  //  Save to Doctors
  Future<bool> saveToHive({
    required String name,
    required String speciality,
    required String phoneNumber,
    required String timing,
    required String status,
    required String isStartGoing,
  }) async {
    try {
      final box = await _openBox();
      final requestData = {
        "name": name,
        'speciality': speciality,
        "pnoneNumber": phoneNumber,
        "timing": timing,
        "status": status,
      };
      await box.add(requestData);
      checkDatabaseStatus();
      log('Saved data(Hive) : $requestData');
      return true;
    } catch (e) {
      log('saveToHive error: $e');
      return false;
    }
  }

  //Edit hive
  Future<void> updateDoctor(
    int index,
    String updatedStatus,
    String? time,
    bool isStartGoing,
  ) async {
    try {
      final box = await _openBox();
      final oldData = Map<String, dynamic>.from(box.getAt(index));
      oldData['status'] = updatedStatus;
      oldData['timing'] = time ?? '1:00';
      // save updated data
      await box.putAt(index, oldData); //Update Both No Issue
      log('Updated status at $index: $updatedStatus');
      log('Updated status at $index: $time');
      await checkDatabaseStatus();
      state = state.copyWith(isStartGoing: isStartGoing);
    } catch (e) {
      log('updateJobRequest error: $e');
    }
  }

  //edit Isgoing
  Future<void> updateIsGoing(
    int index,
    String isGoing,
    bool isStartGoing,
  ) async {
    try {
      final box = await _openBox();
      final oldData = Map<String, dynamic>.from(box.getAt(index));
      // update only status
      oldData['isGo'] = isGoing;

      // save updated data
      await box.putAt(index, oldData);
      log('Updated status at $index: $isGoing');
      state = state.copyWith(isStartGoing: isStartGoing);
      await checkDatabaseStatus();
    } catch (e) {
      log('updateJobRequest error: $e');
    }
  }

  //edit isReach
  Future<void> updateIsReach(int index, String isReach) async {
    try {
      final box = await _openBox();
      final oldData = Map<String, dynamic>.from(box.getAt(index));

      // update only status
      oldData['isReach'] = isReach;

      // save updated data
      await box.putAt(index, oldData);

      log('Updated status at $index: $isReach');

      await checkDatabaseStatus();
    } catch (e) {
      log('updateJobRequest error: $e');
    }
  }

  void setIndex(int index) {
    state = state.copyWith(doctorCount: index);
  }

  void setIsOn(bool isOn) {
    state = state.copyWith(isOn: isOn);
  }

  void setIsGoing(bool isGoing) {
    state = state.copyWith(isGoing: isGoing);
  }
}

// Provider for home screen
final homeScreenProvider =
    StateNotifierProvider<HomeScreenNotifier, HomeScreenState>((ref) {
      return HomeScreenNotifier();
    });

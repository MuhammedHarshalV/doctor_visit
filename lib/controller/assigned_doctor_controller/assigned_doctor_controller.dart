import 'dart:developer';

import 'package:doctor_visit/apis/add_doctor/area_fetch_api.dart';
import 'package:doctor_visit/apis/assign_doctors_api/assign_doctors_api.dart';
import 'package:doctor_visit/apis/assigned_doctors_screen/delete_assigned_doctor_api.dart';
import 'package:doctor_visit/apis/assigned_doctors_screen/get_doctors_area_id.dart';
import 'package:doctor_visit/apis/assigned_doctors_screen/weekly_assigned_doctor_history.dart';
import 'package:doctor_visit/controller/assigned_doctor_controller/assigned_doctor_state.dart';
import 'package:doctor_visit/model/add_doctor_screen/area_or_speciality_fetch_response_model.dart';
import 'package:doctor_visit/model/doctos_assign_get/assigned_doctors_by_area_response_model.dart';
import 'package:doctor_visit/model/doctos_assign_get/weekly_assign_history_response_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AssignedDoctorController extends StateNotifier<AssignedDoctorState> {
  AssignedDoctorController() : super(AssignedDoctorState()) {
    iniatialCall();
  }
  Future<void> iniatialCall() async {
    await areaFetchApi();
    await weeklyAssignedHistory();
  }

  @override
  void dispose() {
    log('Assigned controller Dispose.');
    super.dispose();
  }

  //area fetching
  Future<void> areaFetchApi() async {
    final AreaOrSpecialityFetchResponseModel? response =
        await AreaFetchApi.areaFetchApi();
    if (response != null && response.status == true) {
      state = state.copyWith(areaList: response.data ?? []);
      log('controller response : ${response.data}');
    } else {
      log('add doctor controller error');
    }
  }

  //weekly date increase
  void weeklyDateIncreasing() {
    final currentDate = DateTime.parse(state.weeklyDate);
    final maxDate = DateTime.now().add(const Duration(days: 2));

    if (currentDate.isBefore(maxDate) ||
        currentDate.isAtSameMomentAs(maxDate)) {
      state = state.copyWith(weeklyAssignList: []);
      state = state.copyWith(
        weeklyDate: DateFormat(
          'yyyy-MM-dd',
        ).format(currentDate.add(const Duration(days: 1))),
      );
      if (state.originalWeeklyAssignList.any(
        (doctor) => doctor.assignedDate.toString().contains(state.weeklyDate),
      )) {
        final filteredList = state.originalWeeklyAssignList.where((doctor) {
          return doctor.assignedDate.toString().contains(state.weeklyDate);
        }).toList();

        state = state.copyWith(weeklyAssignList: filteredList);
        log(filteredList.toString());
      }
    }
  }

  //weekly date decreasing
  void weeklyDateDecreasing() {
    final currentDate = DateTime.parse(state.weeklyDate);

    final today = DateTime.now();
    final minDate = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 3));

    if (currentDate.isAfter(minDate)) {
      state = state.copyWith(weeklyAssignList: []);
      final previousDate = currentDate.subtract(const Duration(days: 1));

      state = state.copyWith(
        weeklyDate: DateFormat('yyyy-MM-dd').format(previousDate),
      );

      final filteredList = state.originalWeeklyAssignList.where((doctor) {
        return doctor.assignedDate?.toString().contains(state.weeklyDate) ??
            false;
      }).toList();

      state = state.copyWith(weeklyAssignList: filteredList);
    }
  }

  //weekly assigned history calling
  Future<void> weeklyAssignedHistory() async {
    try {
      state = state.copyWith(isloadDrList: true);
      final WeeklyAssignedDoctorResponseModel response =
          await WeeklyAssignedDoctorHistoryApi.weeklyAssignedDoctorHistory();
      if (response.weeklyDrList != null) {
        state = state.copyWith(
          originalWeeklyAssignList: response.weeklyDrList ?? [],
        );
        List<WeeklyDrList> list = response.weeklyDrList ?? [];
        if (list.any(
          (doctor) => doctor.assignedDate.toString().contains(state.weeklyDate),
        )) {
          final filteredList = list.where((doctor) {
            return doctor.assignedDate.toString().contains(state.weeklyDate);
          }).toList();

          state = state.copyWith(weeklyAssignList: filteredList);
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isloadDrList: false);
    }
  }

  //is edit on
  bool isEditOn() {
    final selectedDate = DateTime.parse(state.weeklyDate);
    final today = DateTime.now();

    final currentDate = DateTime(today.year, today.month, today.day);

    return !selectedDate.isBefore(currentDate);
  }

  //area switching time filter doctors list
  Future<void> assignedDoctorArea({
    required String areaID,
    required String date,
  }) async {
    try {
      state = state.copyWith(isloadDrList: true);
      final AssignedDoctorByAreaResponseModel response =
          await GetDoctorsAreaid.getDoctorsAreaid(areaID: areaID, date: date);

      if (response.drList != null) {
        state = state.copyWith(doctorsList: response.drList ?? []);
        final List<DrList> freeList = [];
        final List<DrList> bookedList = [];
        for (final doctor in response.drList!) {
          if (doctor.assignedProId == null || doctor.assignedProId == 0) {
            freeList.add(doctor);
          } else {
            bookedList.add(doctor);
          }
        }
        state = state.copyWith(
          originalFreeList: freeList,
          originalBookedList: bookedList,
        );
        searchDoctors();
      } else {
        state = state.copyWith(doctorsList: [], freeList: [], bookedList: []);
      }
    } catch (e, stackTrace) {
      log('assignedDoctorArea Error: $e');
      log(stackTrace.toString());

      state = state.copyWith(doctorsList: [], freeList: [], bookedList: []);
    } finally {
      state = state.copyWith(isloadDrList: false);
    }
  }

  //search filter
  void searchDoctors() {
    state = state.copyWith(isloadDrList: true);
    if (state.searchText == 'Available') {
      final filteredList = state.originalFreeList.where((doctor) {
        return doctor.drName?.toLowerCase().contains(state.searchController) ??
            false;
      }).toList();

      state = state.copyWith(freeList: filteredList);
    } else {
      final filteredList = state.originalBookedList.where((doctor) {
        return doctor.drName?.toLowerCase().contains(state.searchController) ??
            false;
      }).toList();

      state = state.copyWith(bookedList: filteredList);
    }
    state = state.copyWith(isloadDrList: false);
  }

  //selected doctors function
  bool isDoctorSelected(int doctorId) {
    if (state.selectedList.contains(doctorId)) {
      state = state.copyWith(selectedList: [...state.selectedList, doctorId]);
      return true;
    }
    if (state.selectedList.contains(doctorId)) {
      state.selectedList.remove(doctorId);
    }
    return false;
  }

  //add doctor
  void addDoctorRemove(int doctorId) {
    final updatedList = [...state.selectedList];

    if (updatedList.contains(doctorId)) {
      updatedList.remove(doctorId);
      //log('corrent list remove: ${state.selectedList.toString()}');
    } else {
      updatedList.add(doctorId);
      // log('corrent list add: ${state.selectedList.toString()}');
    }

    state = state.copyWith(selectedList: updatedList);
    log('selectedList : ${state.selectedList.toString()}');
  }

  // area name to area id
  int areaNametoareaId({required String areaName}) {
    try {
      return state.areaList
              .firstWhere((element) => element.desc == areaName)
              .key ??
          0;
    } catch (_) {
      return 0;
    }
  }

  //scroll controller update
  void updateScrollStatus(bool value) {
    state = state.copyWith(isScrolled: value);
  }

  //clicked status change
  void updateStateClass({
    int? clicked,
    String? areaSelected,
    String? dateSelected,
    String? searchText,
    String? searchController,
  }) {
    state = state.copyWith(
      clicked: clicked ?? state.clicked,
      areaSelected: areaSelected ?? state.areaSelected,
      dateSelected: dateSelected ?? dateSelected,
      searchText: searchText ?? searchText,
      searchController: searchController ?? searchController,
    );
  }

  //assign doctor api
  Future<void> assignDoctorsApi() async {
    state = state.copyWith(isSaving: true);
    try {
      final bool response = await AssignDoctorsApi.assignDoctorsApi(
        date: state.dateSelected,
        doctorIDs: state.selectedList,
      );
      if (response == true) {
        state = state.copyWith(selectedList: []);
        int areaId = areaNametoareaId(areaName: state.areaSelected);
        await assignedDoctorArea(
          areaID: areaId.toString(),
          date: state.dateSelected,
        );
      }
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  //delete assigned doctors
  Future<void> deteleAssigneddoctors({
    required String date,
    required String drID,
  }) async {
    try {
      final dynamic response =
          await DeleteAssignedDoctorApi.deleteAssignedDoctorApi(
            date: date,
            drId: drID,
          );
      if (response == true) {
        final original = [...state.originalWeeklyAssignList];

        original.removeWhere((e) => e.drId.toString() == drID);

        final filtered = original.where((doctor) {
          return doctor.assignedDate?.toString().contains(state.weeklyDate) ??
              false;
        }).toList();

        state = state.copyWith(
          originalWeeklyAssignList: original,
          weeklyAssignList: filtered,
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

// Provider for home screen
final assignedScreenProvider =
    StateNotifierProvider.autoDispose<
      AssignedDoctorController,
      AssignedDoctorState
    >((ref) {
      return AssignedDoctorController();
    });

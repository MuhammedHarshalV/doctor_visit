import 'package:doctor_visit/model/add_doctor_screen/area_or_speciality_fetch_response_model.dart';
import 'package:doctor_visit/model/doctos_assign_get/assigned_doctors_by_area_response_model.dart'
    show DrList;
import 'package:doctor_visit/model/doctos_assign_get/weekly_assign_history_response_model.dart';
import 'package:intl/intl.dart';

class AssignedDoctorState {
  final List<int> selectedList;
  final String searchText;
  final bool isloadDrList;
  final int clicked;
  final String areaSelected;
  final String dateSelected;
  final String weeklyDate;
  final List<Datum> areaList;
  final List<DrList> doctorsList;
  final List<DrList> bookedList;
  final List<DrList> freeList;
  final List<DrList> originalBookedList;
  final List<DrList> originalFreeList;
  final String searchController;
  final bool isSaving;
  final bool isScrolled;
  final List<WeeklyDrList> weeklyAssignList;
  final List<WeeklyDrList> originalWeeklyAssignList;

  AssignedDoctorState({
    this.isSaving = false,
    this.selectedList = const [],
    this.weeklyAssignList = const [],
    this.originalWeeklyAssignList = const [],

    this.searchController = '',
    this.searchText = 'Available',
    this.clicked = 1,
    this.areaSelected = '',
    this.areaList = const [],
    this.doctorsList = const [],
    this.bookedList = const [],
    this.freeList = const [],
    this.originalBookedList = const [],
    this.originalFreeList = const [],

    this.isloadDrList = false,
    this.isScrolled = false,
    String? dateSelected,
    String? weeklyDate,
  }) : dateSelected =
           dateSelected ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
       weeklyDate =
           weeklyDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

  AssignedDoctorState copyWith({
    bool? isSaving,
    List<int>? selectedList,
    String? searchController,
    String? searchText,
    bool? isloadDrList,
    int? clicked,
    String? areaSelected,
    String? dateSelected,
    List<Datum>? areaList,
    List<DrList>? doctorsList,
    List<DrList>? freeList,
    List<DrList>? bookedList,
    List<DrList>? originalFreeList,
    List<DrList>? originalBookedList,
    String? weeklyDate,
    bool? isScrolled,
    List<WeeklyDrList>? weeklyAssignList,
    List<WeeklyDrList>? originalWeeklyAssignList,
  }) {
    return AssignedDoctorState(
      isSaving: isSaving ?? this.isSaving,
      selectedList: selectedList ?? this.selectedList,
      searchController: searchController ?? this.searchController,
      clicked: clicked ?? this.clicked,
      areaList: areaList ?? this.areaList,
      doctorsList: doctorsList ?? this.doctorsList,
      freeList: freeList ?? this.freeList,
      bookedList: bookedList ?? this.bookedList,
      searchText: searchText ?? this.searchText,
      isloadDrList: isloadDrList ?? this.isloadDrList,
      dateSelected: dateSelected ?? this.dateSelected,
      areaSelected: areaSelected ?? this.areaSelected,
      isScrolled: isScrolled ?? this.isScrolled,
      weeklyDate: weeklyDate ?? this.weeklyDate,
      originalBookedList: originalBookedList ?? this.originalBookedList,
      originalFreeList: originalFreeList ?? this.originalFreeList,
      weeklyAssignList: weeklyAssignList ?? this.weeklyAssignList,
      originalWeeklyAssignList:
          originalWeeklyAssignList ?? this.originalWeeklyAssignList,
    );
  }
}

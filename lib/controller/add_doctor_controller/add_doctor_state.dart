class AddDoctorsState {
  final bool isSubmitted;

  AddDoctorsState({this.isSubmitted = false});

  AddDoctorsState copyWith({bool? isSubmitted}) {
    return AddDoctorsState(isSubmitted: isSubmitted ?? this.isSubmitted);
  }
}

class BottomNavState {
  final int currentIndex;

  BottomNavState({required this.currentIndex});

  BottomNavState copyWith({int? currentIndex}) {
    return BottomNavState(currentIndex: currentIndex ?? this.currentIndex);
  }
}
import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final int currentIndex;
  final bool isListOpen;

  const DashboardState({
    this.currentIndex = 0,
    this.isListOpen = false,
  });

  DashboardState copyWith({
    int? currentIndex,
    bool? isListOpen,
  }) {
    return DashboardState(
      currentIndex: currentIndex ?? this.currentIndex,
      isListOpen: isListOpen ?? this.isListOpen,
    );
  }

  @override
  List<Object?> get props => [currentIndex, isListOpen];
}

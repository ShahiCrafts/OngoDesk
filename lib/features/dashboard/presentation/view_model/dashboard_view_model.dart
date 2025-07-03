import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  DashboardViewModel() : super(const DashboardState()) {
    on<TabChanged>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });

    on<ToggleCommunityList>((event, emit) {
      emit(state.copyWith(isListOpen: !state.isListOpen));
    });
  }
}

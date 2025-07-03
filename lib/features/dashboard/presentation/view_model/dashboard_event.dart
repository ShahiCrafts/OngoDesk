import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class TabChanged extends DashboardEvent {
  final int index;

  const TabChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleCommunityList extends DashboardEvent {}

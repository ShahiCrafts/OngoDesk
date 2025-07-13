import 'package:equatable/equatable.dart';

class PollOptionEntity extends Equatable {
  final String label;
  final int votes;

  const PollOptionEntity({
    required this.label,
    this.votes = 0,
  });

  @override
  List<Object?> get props => [label, votes];
}
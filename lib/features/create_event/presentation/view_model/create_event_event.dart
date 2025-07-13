import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'create_event_state.dart';

abstract class CreateEventEvent extends Equatable {
  const CreateEventEvent();

  @override
  List<Object?> get props => [];
}

class CreateEventTitleChanged extends CreateEventEvent {
  const CreateEventTitleChanged(this.title);
  final String title;

  @override
  List<Object> get props => [title];
}

class CreateEventLocationChanged extends CreateEventEvent {
  const CreateEventLocationChanged(this.location);
  final String location;

  @override
  List<Object> get props => [location];
}

class CreateEventDescriptionChanged extends CreateEventEvent {
  const CreateEventDescriptionChanged(this.description);
  final String description;

  @override
  List<Object> get props => [description];
}

class CreateEventContactChanged extends CreateEventEvent {
  const CreateEventContactChanged(this.contact);
  final String contact;

  @override
  List<Object> get props => [contact];
}

class CreateEventStartDateChanged extends CreateEventEvent {
  const CreateEventStartDateChanged(this.startDate);
  final DateTime? startDate;

  @override
  List<Object?> get props => [startDate];
}

class CreateEventEndDateChanged extends CreateEventEvent {
  const CreateEventEndDateChanged(this.endDate);
  final DateTime? endDate;

  @override
  List<Object?> get props => [endDate];
}

class CreateEventLocationTypeChanged extends CreateEventEvent {
  const CreateEventLocationTypeChanged(this.locationType);
  final LocationType locationType;

  @override
  List<Object> get props => [locationType];
}

class CreateEventCoverImagePicked extends CreateEventEvent {
  const CreateEventCoverImagePicked(this.source);
  final ImageSource source;

  @override
  List<Object> get props => [source];
}

class CreateEventMaxAttendeesChanged extends CreateEventEvent {
  const CreateEventMaxAttendeesChanged(this.maxAttendees);
  final int? maxAttendees;

  @override
  List<Object?> get props => [maxAttendees];
}

class CreateEventAllowInvitesToggled extends CreateEventEvent {
  const CreateEventAllowInvitesToggled(this.value);
  final bool value;

  @override
  List<Object> get props => [value];
}

class CreateEventEnableWaitlistToggled extends CreateEventEvent {
  const CreateEventEnableWaitlistToggled(this.value);
  final bool value;

  @override
  List<Object> get props => [value];
}

class CreateEventSendRemindersToggled extends CreateEventEvent {
  const CreateEventSendRemindersToggled(this.value);
  final bool value;

  @override
  List<Object> get props => [value];
}

class CreateEventRequireRSVPToggled extends CreateEventEvent {
  const CreateEventRequireRSVPToggled(this.value);
  final bool value;

  @override
  List<Object> get props => [value];
}

class CreateEventSubmitted extends CreateEventEvent {}

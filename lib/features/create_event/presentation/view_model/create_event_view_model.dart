import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'create_event_event.dart';
import 'create_event_state.dart';

class CreateEventViewModel extends Bloc<CreateEventEvent, CreateEventState> {
  final ImagePicker _picker = ImagePicker();

  CreateEventViewModel() : super(const CreateEventState()) {
    on<CreateEventTitleChanged>(_onTitleChanged);
    on<CreateEventLocationChanged>(_onLocationChanged);
    on<CreateEventDescriptionChanged>(_onDescriptionChanged);
    on<CreateEventContactChanged>(_onContactChanged);
    on<CreateEventStartDateChanged>(_onStartDateChanged);
    on<CreateEventEndDateChanged>(_onEndDateChanged);
    on<CreateEventLocationTypeChanged>(_onLocationTypeChanged);
    on<CreateEventCoverImagePicked>(_onCoverImagePicked);
    on<CreateEventMaxAttendeesChanged>(_onMaxAttendeesChanged);
    on<CreateEventEnableWaitlistToggled>(_onEnableWaitlistToggled);
    on<CreateEventSendRemindersToggled>(_onSendRemindersToggled);
    on<CreateEventRequireRSVPToggled>(_onRequireRSVPToggled);
    on<CreateEventSubmitted>(_onSubmitted);
  }

  void _onTitleChanged(
    CreateEventTitleChanged event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onLocationChanged(
    CreateEventLocationChanged event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(location: event.location));
  }

  void _onDescriptionChanged(
    CreateEventDescriptionChanged event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onContactChanged(
    CreateEventContactChanged event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(contact: event.contact));
  }

  void _onStartDateChanged(
    CreateEventStartDateChanged event,
    Emitter<CreateEventState> emit,
  ) {
    final startDate = event.startDate;
    emit(state.copyWith(startDate: startDate));

    if (startDate != null &&
        state.endDate != null &&
        state.endDate!.isBefore(startDate)) {
      emit(state.copyWith(endDate: startDate.add(const Duration(hours: 1))));
    }
  }

  void _onEndDateChanged(
    CreateEventEndDateChanged event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(endDate: event.endDate));
  }

  void _onLocationTypeChanged(
    CreateEventLocationTypeChanged event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(locationType: event.locationType));
  }

  Future<void> _onCoverImagePicked(
    CreateEventCoverImagePicked event,
    Emitter<CreateEventState> emit,
  ) async {
    final XFile? image = await _picker.pickImage(source: event.source);
    if (image != null) {
      emit(
        state.copyWith(
          coverImage: image,
          imageUploadStatus: ImageUploadStatus.initial,
        ),
      );
    }
  }

  void _onMaxAttendeesChanged(
    CreateEventMaxAttendeesChanged event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(maxAttendees: event.maxAttendees));
  }

  void _onEnableWaitlistToggled(
    CreateEventEnableWaitlistToggled event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(enableWaitlist: event.value));
  }

  void _onSendRemindersToggled(
    CreateEventSendRemindersToggled event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(sendReminders: event.value));
  }

  void _onRequireRSVPToggled(
    CreateEventRequireRSVPToggled event,
    Emitter<CreateEventState> emit,
  ) {
    emit(state.copyWith(requireRSVP: event.value));
  }

  void _onSubmitted(
    CreateEventSubmitted event,
    Emitter<CreateEventState> emit,
  ) {
    // Logic for form submission would go here.
    // For now, we just check validation.
    if (state.isFormValid) {
      print('Event Submitted: ${state.title}');
    }
  }
}

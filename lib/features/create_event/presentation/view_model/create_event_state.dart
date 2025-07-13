import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum LocationType { physical, online }

enum ImageUploadStatus { initial, uploading, success, failure }

class CreateEventState extends Equatable {
  const CreateEventState({
    this.title = '',
    this.location = '',
    this.description = '',
    this.contact = '',
    this.startDate,
    this.endDate,
    this.locationType = LocationType.physical,
    this.coverImage,
    this.maxAttendees,
    this.allowInvites = true,
    this.enableWaitlist = false,
    this.sendReminders = true,
    this.requireRSVP = false,
    this.imageUploadStatus = ImageUploadStatus.initial,
  });

  final String title;
  final String location;
  final String description;
  final String contact;
  final DateTime? startDate;
  final DateTime? endDate;
  final LocationType locationType;
  final XFile? coverImage;
  final int? maxAttendees;
  final bool allowInvites;
  final bool enableWaitlist;
  final bool sendReminders;
  final bool requireRSVP;
  final ImageUploadStatus imageUploadStatus;

  bool get isFormValid =>
      title.isNotEmpty && location.isNotEmpty && startDate != null;

  CreateEventState copyWith({
    String? title,
    String? location,
    String? description,
    String? contact,
    DateTime? startDate,
    DateTime? endDate,
    LocationType? locationType,
    XFile? coverImage,
    bool clearCoverImage = false,
    int? maxAttendees,
    bool? allowInvites,
    bool? enableWaitlist,
    bool? sendReminders,
    bool? requireRSVP,
    ImageUploadStatus? imageUploadStatus,
  }) {
    return CreateEventState(
      title: title ?? this.title,
      location: location ?? this.location,
      description: description ?? this.description,
      contact: contact ?? this.contact,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      locationType: locationType ?? this.locationType,
      coverImage: clearCoverImage ? null : coverImage ?? this.coverImage,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      allowInvites: allowInvites ?? this.allowInvites,
      enableWaitlist: enableWaitlist ?? this.enableWaitlist,
      sendReminders: sendReminders ?? this.sendReminders,
      requireRSVP: requireRSVP ?? this.requireRSVP,
      imageUploadStatus: imageUploadStatus ?? this.imageUploadStatus,
    );
  }

  @override
  List<Object?> get props => [
    title,
    location,
    description,
    contact,
    startDate,
    endDate,
    locationType,
    coverImage,
    maxAttendees,
    allowInvites,
    enableWaitlist,
    sendReminders,
    requireRSVP,
  ];
}

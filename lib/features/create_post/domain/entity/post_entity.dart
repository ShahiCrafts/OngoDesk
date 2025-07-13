import 'package:equatable/equatable.dart';
import 'package:ongo_desk/features/create_post/domain/entity/poll_option_entity.dart';

import '../../presentation/view_model/post_type_enum.dart';

enum PriorityLevel { low, medium, high, critical }

enum Visibility { public, admin }

enum EventLocationType { online, physical }

enum PollStatus { active, closed }

class PostEntity extends Equatable {
  final String? id;
  final PostType type;
  final String authorId;
  final String? communityId;
  final String? title;
  final String? content;
  final List<String> tags;
  final List<String> attachments;
  final Visibility visibility;
  final bool allowComments;

  // For Report Issue
  final String? categoryId;
  final PriorityLevel? priorityLevel;
  final String? responsibleDepartment;
  final String? address;
  final String? nearbyLandmark;
  final String? contactInfo;
  final String? expectedResolutionTime;

  // For Events
  final String? eventDescription;
  final DateTime? eventStartDate;
  final DateTime? eventEndDate;
  final EventLocationType? locationType;
  final String? locationDetails;
  final bool? requireRSVP;
  final int? maxAttendees;
  final bool? enableWaitlist;
  final bool? sendReminders;

  // For Polls
  final String? question;
  final List<PollOptionEntity> options;
  final int totalVotes;
  final DateTime? pollEndsAt;
  final bool? notifyOnClose;
  final bool? allowMultipleSelections;
  final PollStatus? status;

  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PostEntity({
    this.id,
    required this.type,
    required this.authorId,
    this.communityId,
    this.title,
    this.content,
    this.tags = const [],
    this.attachments = const [],
    this.visibility = Visibility.public,
    this.allowComments = true,
    this.categoryId,
    this.priorityLevel,
    this.responsibleDepartment,
    this.address,
    this.nearbyLandmark,
    this.contactInfo,
    this.expectedResolutionTime,
    this.eventDescription,
    this.eventStartDate,
    this.eventEndDate,
    this.locationType,
    this.locationDetails,
    this.requireRSVP,
    this.maxAttendees,
    this.enableWaitlist,
    this.sendReminders,
    this.question,
    this.options = const [],
    this.totalVotes = 0,
    this.pollEndsAt,
    this.notifyOnClose,
    this.allowMultipleSelections,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    authorId,
    communityId,
    title,
    content,
    tags,
    attachments,
    visibility,
    allowComments,
    categoryId,
    priorityLevel,
    responsibleDepartment,
    address,
    nearbyLandmark,
    contactInfo,
    expectedResolutionTime,
    eventDescription,
    eventStartDate,
    eventEndDate,
    locationType,
    locationDetails,
    requireRSVP,
    maxAttendees,
    enableWaitlist,
    sendReminders,
    question,
    options,
    totalVotes,
    pollEndsAt,
    notifyOnClose,
    allowMultipleSelections,
    status,
    createdAt,
    updatedAt,
  ];
}

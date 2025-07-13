import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ongo_desk/features/create_post/domain/entity/poll_option_entity.dart';
import 'package:ongo_desk/features/create_post/domain/entity/post_entity.dart';
import 'package:ongo_desk/features/create_post/presentation/view_model/post_type_enum.dart';

part 'post_api_model.g.dart';

// This annotation is critical. It tells the JSON serializer to skip any
// fields that are null, preventing them from being sent as empty strings.
@JsonSerializable(includeIfNull: false)
class PostApiModel extends Equatable {
  @JsonKey(name: '_id', includeIfNull: false)
  final String? id;

  final String type;
  final String authorId;
  final String? communityId;
  final String? title;
  final String? content;
  final List<String>? tags;
  final List<String>? attachments;
  final String? visibility;
  final bool? allowComments;

  // For Report Issue
  final String? categoryId;
  final String? priorityLevel;
  final String? responsibleDepartment;
  final String? address;
  final String? nearbyLandmark;
  final String? contactInfo;
  final String? expectedResolutionTime;

  // For Events
  final String? eventDescription;
  final DateTime? eventStartDate;
  final DateTime? eventEndDate;
  final String? locationType;
  final String? locationDetails;
  final bool? requireRSVP;
  final int? maxAttendees;
  final bool? enableWaitlist;
  final bool? sendReminders;

  // For Polls
  final String? question;
  final List<PollOptionApiModel>? options;
  final int? totalVotes;
  final DateTime? pollEndsAt;
  final bool? notifyOnClose;
  final bool? allowMultipleSelections;
  final String? status;

  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PostApiModel({
    this.id,
    required this.type,
    required this.authorId,
    this.communityId,
    this.title,
    this.content,
    this.tags,
    this.attachments,
    this.visibility,
    this.allowComments,
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
    this.options,
    this.totalVotes,
    this.pollEndsAt,
    this.notifyOnClose,
    this.allowMultipleSelections,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PostApiModel.fromJson(Map<String, dynamic> json) =>
      _$PostApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostApiModelToJson(this);

  PostEntity toEntity() {
    T enumFromString<T>(List<T> values, String? value, T defaultValue) {
        if (value == null) return defaultValue;

        if (T == PostType) {
            switch (value) {
                case "Discussion":
                    return PostType.discussion as T;
                case "Report Issue":
                    return PostType.standard as T; // Map "Report Issue" back to standard
                case "Poll":
                    return PostType.poll as T;
                default:
                    return defaultValue;
            }
        }
        // Fallback for other enums
        return values.firstWhere(
            (e) => (e as Enum).name.toLowerCase() == value.toLowerCase().replaceAll('-', '').replaceAll(' ', ''),
            orElse: () => defaultValue,
        );
    }

    return PostEntity(
      id: id,
      type: enumFromString(PostType.values, type, PostType.discussion),
      authorId: authorId,
      communityId: communityId,
      title: title,
      content: content,
      tags: tags ?? [],
      attachments: attachments ?? [],
      visibility: enumFromString(Visibility.values, visibility, Visibility.public),
      allowComments: allowComments ?? true,
      categoryId: categoryId,
      priorityLevel: priorityLevel != null ? enumFromString(PriorityLevel.values, priorityLevel, PriorityLevel.low) : null,
      responsibleDepartment: responsibleDepartment,
      address: address,
      nearbyLandmark: nearbyLandmark,
      contactInfo: contactInfo,
      expectedResolutionTime: expectedResolutionTime,
      eventDescription: eventDescription,
      eventStartDate: eventStartDate,
      eventEndDate: eventEndDate,
      locationType: locationType != null ? enumFromString(EventLocationType.values, locationType, EventLocationType.online) : null,
      locationDetails: locationDetails,
      requireRSVP: requireRSVP,
      maxAttendees: maxAttendees,
      enableWaitlist: enableWaitlist,
      sendReminders: sendReminders,
      question: question,
      options: options?.map((o) => o.toEntity()).toList() ?? [],
      totalVotes: totalVotes ?? 0,
      pollEndsAt: pollEndsAt,
      notifyOnClose: notifyOnClose,
      allowMultipleSelections: allowMultipleSelections,
      status: status != null ? enumFromString(PollStatus.values, status, PollStatus.active) : null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates an API model from a domain [PostEntity].
  factory PostApiModel.fromEntity(PostEntity entity) {
    // Helper function to convert enums to the exact strings the server expects.
    String? enumToApiString(Enum? e) {
      if (e == null) return null;
      
      // FIX: Updated mapping for the new PostType enum
      if (e is PostType) {
        switch (e) {
          case PostType.discussion:
            return "Discussion";
          case PostType.standard:
            return "Report Issue"; // Map 'standard' to 'Report Issue'
          case PostType.poll:
            return "Poll";
        }
      }
      
      // For other enums
      switch (e) {
        case PriorityLevel.low: return "Low";
        case PriorityLevel.medium: return "Medium";
        case PriorityLevel.high: return "High";
        case PriorityLevel.critical: return "Critical";
        case Visibility.public: return "Public";
        case Visibility.admin: return "Admin";
        case EventLocationType.online: return "Online";
        case EventLocationType.physical: return "In-Person";
        case PollStatus.active: return "ACTIVE";
        case PollStatus.closed: return "CLOSED";
        default: return e.name;
      }
    }

    return PostApiModel(
      id: entity.id,
      type: enumToApiString(entity.type)!,
      authorId: entity.authorId,
      communityId: entity.communityId,
      title: entity.title,
      content: entity.content,
      tags: entity.tags,
      attachments: entity.attachments,
      visibility: enumToApiString(entity.visibility),
      allowComments: entity.allowComments,
      categoryId: entity.categoryId,
      priorityLevel: enumToApiString(entity.priorityLevel),
      responsibleDepartment: entity.responsibleDepartment,
      address: entity.address,
      nearbyLandmark: entity.nearbyLandmark,
      contactInfo: entity.contactInfo,
      expectedResolutionTime: entity.expectedResolutionTime,
      eventDescription: entity.eventDescription,
      eventStartDate: entity.eventStartDate,
      eventEndDate: entity.eventEndDate,
      locationType: enumToApiString(entity.locationType),
      locationDetails: entity.locationDetails,
      requireRSVP: entity.requireRSVP,
      maxAttendees: entity.maxAttendees,
      enableWaitlist: entity.enableWaitlist,
      sendReminders: entity.sendReminders,
      question: entity.question,
      options: entity.options.map((o) => PollOptionApiModel.fromEntity(o)).toList(),
      totalVotes: entity.totalVotes,
      pollEndsAt: entity.pollEndsAt,
      notifyOnClose: entity.notifyOnClose,
      allowMultipleSelections: entity.allowMultipleSelections,
      status: enumToApiString(entity.status),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, type, authorId, communityId, title, content, tags, attachments,
        visibility, allowComments, categoryId, priorityLevel, responsibleDepartment,
        address, nearbyLandmark, contactInfo, expectedResolutionTime, eventDescription,
        eventStartDate, eventEndDate, locationType, locationDetails, requireRSVP,
        maxAttendees, enableWaitlist, sendReminders, question, options, totalVotes,
        pollEndsAt, notifyOnClose, allowMultipleSelections, status, createdAt, updatedAt,
      ];
}

@JsonSerializable()
class PollOptionApiModel extends Equatable {
  final String label;
  final int votes;

  const PollOptionApiModel({
    required this.label,
    this.votes = 0,
  });

  factory PollOptionApiModel.fromJson(Map<String, dynamic> json) =>
      _$PollOptionApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PollOptionApiModelToJson(this);

  PollOptionEntity toEntity() {
    return PollOptionEntity(label: label, votes: votes);
  }

  factory PollOptionApiModel.fromEntity(PollOptionEntity entity) {
    return PollOptionApiModel(label: entity.label, votes: entity.votes);
  }

  @override
  List<Object?> get props => [label, votes];
}

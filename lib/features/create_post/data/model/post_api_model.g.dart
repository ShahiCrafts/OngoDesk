// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostApiModel _$PostApiModelFromJson(Map<String, dynamic> json) => PostApiModel(
      id: json['_id'] as String?,
      type: json['type'] as String,
      authorId: json['authorId'] as String,
      communityId: json['communityId'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      visibility: json['visibility'] as String?,
      allowComments: json['allowComments'] as bool?,
      categoryId: json['categoryId'] as String?,
      priorityLevel: json['priorityLevel'] as String?,
      responsibleDepartment: json['responsibleDepartment'] as String?,
      address: json['address'] as String?,
      nearbyLandmark: json['nearbyLandmark'] as String?,
      contactInfo: json['contactInfo'] as String?,
      expectedResolutionTime: json['expectedResolutionTime'] as String?,
      eventDescription: json['eventDescription'] as String?,
      eventStartDate: json['eventStartDate'] == null
          ? null
          : DateTime.parse(json['eventStartDate'] as String),
      eventEndDate: json['eventEndDate'] == null
          ? null
          : DateTime.parse(json['eventEndDate'] as String),
      locationType: json['locationType'] as String?,
      locationDetails: json['locationDetails'] as String?,
      requireRSVP: json['requireRSVP'] as bool?,
      maxAttendees: (json['maxAttendees'] as num?)?.toInt(),
      enableWaitlist: json['enableWaitlist'] as bool?,
      sendReminders: json['sendReminders'] as bool?,
      question: json['question'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => PollOptionApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalVotes: (json['totalVotes'] as num?)?.toInt(),
      pollEndsAt: json['pollEndsAt'] == null
          ? null
          : DateTime.parse(json['pollEndsAt'] as String),
      notifyOnClose: json['notifyOnClose'] as bool?,
      allowMultipleSelections: json['allowMultipleSelections'] as bool?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PostApiModelToJson(PostApiModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      'type': instance.type,
      'authorId': instance.authorId,
      if (instance.communityId case final value?) 'communityId': value,
      if (instance.title case final value?) 'title': value,
      if (instance.content case final value?) 'content': value,
      if (instance.tags case final value?) 'tags': value,
      if (instance.attachments case final value?) 'attachments': value,
      if (instance.visibility case final value?) 'visibility': value,
      if (instance.allowComments case final value?) 'allowComments': value,
      if (instance.categoryId case final value?) 'categoryId': value,
      if (instance.priorityLevel case final value?) 'priorityLevel': value,
      if (instance.responsibleDepartment case final value?)
        'responsibleDepartment': value,
      if (instance.address case final value?) 'address': value,
      if (instance.nearbyLandmark case final value?) 'nearbyLandmark': value,
      if (instance.contactInfo case final value?) 'contactInfo': value,
      if (instance.expectedResolutionTime case final value?)
        'expectedResolutionTime': value,
      if (instance.eventDescription case final value?)
        'eventDescription': value,
      if (instance.eventStartDate?.toIso8601String() case final value?)
        'eventStartDate': value,
      if (instance.eventEndDate?.toIso8601String() case final value?)
        'eventEndDate': value,
      if (instance.locationType case final value?) 'locationType': value,
      if (instance.locationDetails case final value?) 'locationDetails': value,
      if (instance.requireRSVP case final value?) 'requireRSVP': value,
      if (instance.maxAttendees case final value?) 'maxAttendees': value,
      if (instance.enableWaitlist case final value?) 'enableWaitlist': value,
      if (instance.sendReminders case final value?) 'sendReminders': value,
      if (instance.question case final value?) 'question': value,
      if (instance.options case final value?) 'options': value,
      if (instance.totalVotes case final value?) 'totalVotes': value,
      if (instance.pollEndsAt?.toIso8601String() case final value?)
        'pollEndsAt': value,
      if (instance.notifyOnClose case final value?) 'notifyOnClose': value,
      if (instance.allowMultipleSelections case final value?)
        'allowMultipleSelections': value,
      if (instance.status case final value?) 'status': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };

PollOptionApiModel _$PollOptionApiModelFromJson(Map<String, dynamic> json) =>
    PollOptionApiModel(
      label: json['label'] as String,
      votes: (json['votes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PollOptionApiModelToJson(PollOptionApiModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'votes': instance.votes,
    };

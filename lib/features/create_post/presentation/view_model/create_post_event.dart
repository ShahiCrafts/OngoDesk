import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ongo_desk/features/create_post/domain/entity/category_entity.dart';
import 'package:ongo_desk/features/create_post/domain/entity/community_entity.dart';
import 'post_type_enum.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();
  @override
  List<Object?> get props => [];
}

// General Events
class TitleChanged extends CreatePostEvent {
  final String title;
  const TitleChanged(this.title);
  @override
  List<Object?> get props => [title];
}

class BodyChanged extends CreatePostEvent {
  final String body;
  const BodyChanged(this.body);
  @override
  List<Object?> get props => [body];
}

class ToggleVisibility extends CreatePostEvent {}

class ToggleComments extends CreatePostEvent {}

class ImagesAdded extends CreatePostEvent {
  final List<XFile> images;
  const ImagesAdded(this.images);
  @override
  List<Object?> get props => [images];
}

class ImageRemoved extends CreatePostEvent {
  final XFile image;
  const ImageRemoved(this.image);
  @override
  List<Object?> get props => [image];
}

class PostTypeChanged extends CreatePostEvent {
  final PostType type;
  const PostTypeChanged(this.type);
  @override
  List<Object> get props => [type];
}

// Community Events
class FetchCommunities extends CreatePostEvent {}
class CommunitySelected extends CreatePostEvent {
  final CommunityEntity community;
  const CommunitySelected(this.community);
  @override
  List<Object?> get props => [community];
}

// Category Events
class FetchCategories extends CreatePostEvent {}
class CategorySelected extends CreatePostEvent {
  final CategoryEntity category;
  const CategorySelected(this.category);
  @override
  List<Object?> get props => [category];
}

// Poll Events
class PollOptionAdded extends CreatePostEvent {}
class PollOptionRemoved extends CreatePostEvent {
  final int index;
  const PollOptionRemoved(this.index);
  @override
  List<Object?> get props => [index];
}
class PollOptionChanged extends CreatePostEvent {
  final int index;
  final String value;
  const PollOptionChanged(this.index, this.value);
  @override
  List<Object?> get props => [index, value];
}
class PollDurationChanged extends CreatePostEvent {
  final int days;
  const PollDurationChanged(this.days);
  @override
  List<Object?> get props => [days];
}
class AnonymousVotingToggled extends CreatePostEvent {}

// Location Events
class FetchLocation extends CreatePostEvent {}
class LocationUpdated extends CreatePostEvent {
    final String address;
    const LocationUpdated(this.address);
    @override
    List<Object> get props => [address];
}
class LocationRemoved extends CreatePostEvent {}

// Tag Events
class FetchTags extends CreatePostEvent {}
class ShowTagSuggestions extends CreatePostEvent {
  final String query;
  const ShowTagSuggestions(this.query);
  @override
  List<Object?> get props => [query];
}
class HideTagSuggestions extends CreatePostEvent {}

// Submission Event
class SubmitPost extends CreatePostEvent {
    final BuildContext context;
    const SubmitPost({required this.context});
    @override
    List<Object> get props => [context];
}

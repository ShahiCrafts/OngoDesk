import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ongo_desk/features/create_post/domain/entity/category_entity.dart';
import 'package:ongo_desk/features/create_post/domain/entity/community_entity.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';
import 'post_type_enum.dart';

enum FetchStatus { initial, loading, success, failure }
enum CreatePostStatus { initial, loading, success, failure }

class CreatePostState extends Equatable {
  final String title;
  final String body;
  final bool isPublic;
  final bool allowComments;
  final List<XFile> images;
  final PostType postType;

  // Separated Community and Category state
  final CommunityEntity? selectedCommunity;
  final CategoryEntity? selectedCategory;
  final List<CommunityEntity> availableCommunities;
  final List<CategoryEntity> availableCategories;
  final FetchStatus communityStatus;
  final FetchStatus categoryStatus;

  final List<String> pollOptions;
  final int pollEndDays;
  final bool allowAnonymousVoting;

  final String? locationAddress;
  final bool isFetchingLocation;

  final List<TagEntity> availableTags;
  final List<TagEntity> filteredTags;
  final bool showingTagSuggestions;

  final CreatePostStatus createPostStatus;

  const CreatePostState({
    this.title = '',
    this.body = '',
    this.isPublic = true,
    this.allowComments = true,
    this.images = const [],
    this.postType = PostType.standard,
    this.selectedCommunity,
    this.selectedCategory,
    this.availableCommunities = const [],
    this.availableCategories = const [],
    this.communityStatus = FetchStatus.initial,
    this.categoryStatus = FetchStatus.initial,
    this.pollOptions = const [],
    this.pollEndDays = 7,
    this.allowAnonymousVoting = false,
    this.locationAddress,
    this.isFetchingLocation = false,
    this.createPostStatus = CreatePostStatus.initial,
    this.availableTags = const [],
    this.filteredTags = const [],
    this.showingTagSuggestions = false,
  });

  bool get isPoll => postType == PostType.poll;

  CreatePostState copyWith({
    String? title,
    String? body,
    bool? isPublic,
    bool? allowComments,
    List<XFile>? images,
    PostType? postType,
    CommunityEntity? selectedCommunity,
    CategoryEntity? selectedCategory,
    List<CommunityEntity>? availableCommunities,
    List<CategoryEntity>? availableCategories,
    FetchStatus? communityStatus,
    FetchStatus? categoryStatus,
    List<String>? pollOptions,
    int? pollEndDays,
    bool? allowAnonymousVoting,
    String? locationAddress,
    bool? isFetchingLocation,
    bool clearLocation = false,
    List<TagEntity>? availableTags,
    List<TagEntity>? filteredTags,
    bool? showingTagSuggestions,
    CreatePostStatus? createPostStatus,
  }) {
    return CreatePostState(
      title: title ?? this.title,
      body: body ?? this.body,
      isPublic: isPublic ?? this.isPublic,
      allowComments: allowComments ?? this.allowComments,
      images: images ?? this.images,
      postType: postType ?? this.postType,
      selectedCommunity: selectedCommunity ?? this.selectedCommunity,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      availableCommunities: availableCommunities ?? this.availableCommunities,
      availableCategories: availableCategories ?? this.availableCategories,
      communityStatus: communityStatus ?? this.communityStatus,
      categoryStatus: categoryStatus ?? this.categoryStatus,
      pollOptions: pollOptions ?? this.pollOptions,
      pollEndDays: pollEndDays ?? this.pollEndDays,
      allowAnonymousVoting: allowAnonymousVoting ?? this.allowAnonymousVoting,
      locationAddress:
          clearLocation ? null : locationAddress ?? this.locationAddress,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      availableTags: availableTags ?? this.availableTags,
      filteredTags: filteredTags ?? this.filteredTags,
      showingTagSuggestions:
          showingTagSuggestions ?? this.showingTagSuggestions,
      createPostStatus: createPostStatus ?? this.createPostStatus,
    );
  }

  @override
  List<Object?> get props => [
        title, body, isPublic, allowComments, images, postType,
        selectedCommunity, selectedCategory, availableCommunities, availableCategories,
        communityStatus, categoryStatus, pollOptions, pollEndDays,
        allowAnonymousVoting, locationAddress, isFetchingLocation,
        availableTags, filteredTags, showingTagSuggestions, createPostStatus,
      ];
}

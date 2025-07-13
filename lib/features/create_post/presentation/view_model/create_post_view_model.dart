import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ongo_desk/features/create_post/domain/entity/community_entity.dart';
import 'package:ongo_desk/features/create_post/domain/entity/poll_option_entity.dart';
import 'package:ongo_desk/features/create_post/domain/entity/post_entity.dart';
import 'package:ongo_desk/features/create_post/domain/use_case/category_fetch_usecase.dart';
import 'package:ongo_desk/features/create_post/domain/use_case/create_post_usecase.dart';
import 'package:ongo_desk/features/create_post/domain/use_case/tag_fetch_usecase.dart';

import 'create_post_event.dart';
import 'create_post_state.dart';
import 'post_type_enum.dart';

class CreatePostViewModel extends Bloc<CreatePostEvent, CreatePostState> {
  final TagFetchUseCase _tagFetchUseCase;
  final CategoryFetchUseCase _categoryFetchUseCase;
  final CreatePostUsecase _createPostUsecase;

  CreatePostViewModel({
    required TagFetchUseCase tagFetchUseCase,
    required CategoryFetchUseCase categoryFetchUseCase,
    required CreatePostUsecase createPostUsecase,
  })  : _tagFetchUseCase = tagFetchUseCase,
        _categoryFetchUseCase = categoryFetchUseCase,
        _createPostUsecase = createPostUsecase,
        super(const CreatePostState()) {
    
    on<TitleChanged>((event, emit) => emit(state.copyWith(title: event.title)));
    on<BodyChanged>((event, emit) => emit(state.copyWith(body: event.body)));
    on<ToggleVisibility>((event, emit) => emit(state.copyWith(isPublic: !state.isPublic)));
    on<ToggleComments>((event, emit) => emit(state.copyWith(allowComments: !state.allowComments)));
    on<CommunitySelected>((event, emit) => emit(state.copyWith(selectedCommunity: event.community)));
    on<CategorySelected>((event, emit) => emit(state.copyWith(selectedCategory: event.category)));
    on<ImagesAdded>(_onImagesAdded);
    on<ImageRemoved>(_onImageRemoved);
    on<PostTypeChanged>(_onPostTypeChanged);
    on<FetchTags>(_onFetchTags);
    on<FetchCategories>(_onFetchCategories);
    on<FetchCommunities>(_onFetchCommunities);
    on<SubmitPost>(_onSubmitPost);
    on<ShowTagSuggestions>(_onShowTagSuggestions);
    on<HideTagSuggestions>(_onHideTagSuggestions);

    // FIX: Added the missing event handlers for location.
    on<FetchLocation>((event, emit) => emit(state.copyWith(isFetchingLocation: true)));
    on<LocationUpdated>((event, emit) => emit(state.copyWith(locationAddress: event.address, isFetchingLocation: false)));
    on<LocationRemoved>((event, emit) => emit(state.copyWith(clearLocation: true)));
  }

  void _onShowTagSuggestions(ShowTagSuggestions event, Emitter<CreatePostState> emit) {
      final keyword = event.query.toLowerCase();
      final filtered = state.availableTags
          .where((tag) => tag.name.toLowerCase().contains(keyword))
          .toList();
      emit(state.copyWith(filteredTags: filtered, showingTagSuggestions: true));
  }

  void _onHideTagSuggestions(HideTagSuggestions event, Emitter<CreatePostState> emit) {
      emit(state.copyWith(filteredTags: [], showingTagSuggestions: false));
  }

  void _onImagesAdded(ImagesAdded event, Emitter<CreatePostState> emit) {
    final updatedImages = List<XFile>.from(state.images)..addAll(event.images);
    emit(state.copyWith(images: updatedImages));
  }

  void _onImageRemoved(ImageRemoved event, Emitter<CreatePostState> emit) {
    final updatedImages = List<XFile>.from(state.images)..remove(event.image);
    emit(state.copyWith(images: updatedImages));
  }
  
  void _onPostTypeChanged(PostTypeChanged event, Emitter<CreatePostState> emit) {
      final nextType = state.postType == event.type ? PostType.standard : event.type;
      emit(state.copyWith(
          postType: nextType,
          pollOptions: nextType == PostType.poll ? ['Option 1', 'Option 2'] : [],
      ));
  }

  Future<void> _onFetchTags(FetchTags event, Emitter<CreatePostState> emit) async {
    final result = await _tagFetchUseCase();
    result.fold(
      (failure) => null, // Optionally handle failure
      (tags) => emit(state.copyWith(availableTags: tags)),
    );
  }

  Future<void> _onFetchCategories(FetchCategories event, Emitter<CreatePostState> emit) async {
    emit(state.copyWith(categoryStatus: FetchStatus.loading));
    final result = await _categoryFetchUseCase();
    result.fold(
      (failure) => emit(state.copyWith(categoryStatus: FetchStatus.failure)),
      (categories) => emit(state.copyWith(
        categoryStatus: FetchStatus.success,
        availableCategories: categories,
      )),
    );
  }

  Future<void> _onFetchCommunities(FetchCommunities event, Emitter<CreatePostState> emit) async {
    emit(state.copyWith(communityStatus: FetchStatus.loading));
    await Future.delayed(const Duration(milliseconds: 500));
    final mockCommunities = [
      CommunityEntity(id: '687a1b2c3d4e5f6a7b8c9d0e', name: 'General Discussion', description: '', issuesCount: 2),
      CommunityEntity(id: '687a1b2c3d4e5f6a7b8c9d0f', name: 'Local Events', description: '', issuesCount: 2),
      CommunityEntity(id: '687a1b2c3d4e5f6a7b8c9d1a', name: 'Neighborhood Watch', description: '', issuesCount: 2),
    ];
    emit(state.copyWith(
      communityStatus: FetchStatus.success,
      availableCommunities: mockCommunities,
    ));
  }

  Future<void> _onSubmitPost(SubmitPost event, Emitter<CreatePostState> emit) async {
    emit(state.copyWith(createPostStatus: CreatePostStatus.loading));

    List<PollOptionEntity> pollOptions = [];
    if (state.postType == PostType.poll) {
      pollOptions = state.pollOptions
          .where((option) => option.trim().isNotEmpty)
          .map((option) => PollOptionEntity(label: option.trim()))
          .toList();
    }

    final postEntity = PostEntity(
      type: state.postType,
      authorId: 'YOUR_REAL_USER_ID_HERE',
      communityId: state.postType != PostType.standard ? state.selectedCommunity?.id : null,
      categoryId: state.postType == PostType.standard ? state.selectedCategory?.id : null,
      title: state.title,
      content: state.body,
      tags: state.availableTags.map((tag) => tag.name).toList(),
      attachments: state.images.map((xfile) => xfile.path).toList(),
      visibility: state.isPublic ? Visibility.public : Visibility.admin,
      allowComments: state.allowComments,
      address: state.locationAddress,
      question: state.postType == PostType.poll ? state.title : null,
      options: pollOptions,
      pollEndsAt: state.postType == PostType.poll
          ? DateTime.now().add(Duration(days: state.pollEndDays))
          : null,
      allowMultipleSelections: state.allowAnonymousVoting,
    );

    final result = await _createPostUsecase(CreatePostParams(post: postEntity));

    result.fold(
      (failure) => emit(state.copyWith(createPostStatus: CreatePostStatus.failure)),
      (_) => emit(state.copyWith(createPostStatus: CreatePostStatus.success)),
    );
  }
}

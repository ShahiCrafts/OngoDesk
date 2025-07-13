import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ongo_desk/features/create_post/domain/entity/category_entity.dart';
import 'package:ongo_desk/features/create_post/domain/entity/community_entity.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';
import 'package:ongo_desk/features/create_post/presentation/view_model/create_post_event.dart';
import 'package:ongo_desk/features/create_post/presentation/view_model/create_post_state.dart';
import 'package:ongo_desk/features/create_post/presentation/view_model/create_post_view_model.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/post_bottom_toolbar.dart';
import 'package:permission_handler/permission_handler.dart';
import '../view_model/post_type_enum.dart';
import 'widgets/community_selector.dart';
import 'widgets/image_preview.dart';
import 'widgets/location_display.dart';
import 'widgets/poll_editor_card.dart';
import 'widgets/post_action_buttons.dart';
import 'widgets/post_app_bar.dart';
import 'widgets/post_input_fields.dart';
import 'widgets/post_settings.dart';
import 'widgets/tag_suggestion_list.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final bodyController = TextEditingController();
  final titleController = TextEditingController();
  final bodyFocusNode = FocusNode();
  final titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    bodyController.addListener(_onTextChanged);
    context.read<CreatePostViewModel>().add(FetchTags());
    context.read<CreatePostViewModel>().add(FetchCategories());
    context.read<CreatePostViewModel>().add(FetchCommunities());
  }

  @override
  void dispose() {
    bodyController.removeListener(_onTextChanged);
    bodyController.dispose();
    titleController.dispose();
    bodyFocusNode.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  void _selectCommunity(BuildContext context) async {
    final state = context.read<CreatePostViewModel>().state;
    final selected = await showModalBottomSheet<CommunityEntity>(
      context: context,
      builder: (context) {
        switch (state.communityStatus) {
          case FetchStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case FetchStatus.failure:
            return const Center(child: Text('Failed to load communities.'));
          case FetchStatus.success:
            return ListView(
              shrinkWrap: true,
              children:
                  state.availableCommunities.map((community) {
                    return ListTile(
                      title: Text(community.name),
                      onTap: () => Navigator.pop(context, community),
                    );
                  }).toList(),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );

    if (selected != null && context.mounted) {
      context.read<CreatePostViewModel>().add(CommunitySelected(selected));
    }
  }

  void _selectCategory(BuildContext context) async {
    final state = context.read<CreatePostViewModel>().state;
    final selected = await showModalBottomSheet<CategoryEntity>(
      context: context,
      builder: (context) {
        switch (state.categoryStatus) {
          case FetchStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case FetchStatus.failure:
            return const Center(child: Text('Failed to load categories.'));
          case FetchStatus.success:
            return ListView(
              shrinkWrap: true,
              children:
                  state.availableCategories.map((category) {
                    return ListTile(
                      title: Text(category.name),
                      onTap: () => Navigator.pop(context, category),
                    );
                  }).toList(),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );

    if (selected != null && context.mounted) {
      context.read<CreatePostViewModel>().add(CategorySelected(selected));
    }
  }

  void _onTextChanged() {
    final viewModel = context.read<CreatePostViewModel>();
    viewModel.add(BodyChanged(bodyController.text));
    final text = bodyController.text;
    final int cursorPosition = bodyController.selection.baseOffset;
    if (cursorPosition < 0) {
      viewModel.add(HideTagSuggestions());
      return;
    }
    final int lastHashIndex = text.lastIndexOf('#', cursorPosition);
    if (lastHashIndex != -1) {
      final int lastSpaceIndex = text.lastIndexOf(' ', cursorPosition);
      if (lastHashIndex > lastSpaceIndex) {
        final query = text.substring(lastHashIndex + 1, cursorPosition);
        if (!query.contains(' ')) {
          viewModel.add(ShowTagSuggestions(query));
          return;
        }
      }
    }
    viewModel.add(HideTagSuggestions());
  }

  void _onTagSelected(TagEntity tag) {
    final viewModel = context.read<CreatePostViewModel>();
    final text = bodyController.text;
    final int cursorPosition = bodyController.selection.baseOffset;
    final int lastHashIndex = text.lastIndexOf('#', cursorPosition);
    if (lastHashIndex != -1) {
      final newText = '${text.substring(0, lastHashIndex)}#${tag.name} ';
      bodyController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        ),
      );
      viewModel.add(BodyChanged(newText));
    }
    viewModel.add(HideTagSuggestions());
  }

  Future<void> _pickImages(BuildContext context) async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted) {
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo permission required to select images.'),
            ),
          );
        }
        return;
      }
    }
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty && context.mounted) {
      context.read<CreatePostViewModel>().add(ImagesAdded(pickedFiles));
    }
  }

  Future<void> _fetchLocation(BuildContext context) async {
    final viewModel = context.read<CreatePostViewModel>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final wantsToProceed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Use Your Location'),
            content: const Text(
              'To make your post more relevant, we can attach your current location. This helps others understand the context of your post better.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Proceed'),
              ),
            ],
          ),
    );

    if (wantsToProceed != true) return;

    var status = await Permission.location.request();
    if (status.isDenied && context.mounted) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Location permission is required to proceed.'),
        ),
      );
      return;
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return;
    }

    viewModel.add(FetchLocation());

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && context.mounted) {
        final placemark = placemarks.first;
        final address =
            "${placemark.locality}, ${placemark.administrativeArea}";
        viewModel.add(LocationUpdated(address));
      }
    } catch (e) {
      if (context.mounted) {
        viewModel.add(const LocationUpdated(''));
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Could not fetch location: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostViewModel, CreatePostState>(
      builder: (context, state) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        if (titleController.text != state.title) {
          titleController.text = state.title;
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PostAppBar(
            onPost:
                () => context.read<CreatePostViewModel>().add(
                  SubmitPost(context: context),
                ),
          ),
          bottomNavigationBar: AnimatedPadding(
            padding: EdgeInsets.only(
              bottom: keyboardHeight > 0 ? keyboardHeight : 0,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: PostBottomToolbar(
              onAddDiscussion:
                  () => context.read<CreatePostViewModel>().add(
                    const PostTypeChanged(PostType.discussion),
                  ),
              onAddPoll:
                  () => context.read<CreatePostViewModel>().add(
                    const PostTypeChanged(PostType.poll),
                  ),
              onAddImage: () => _pickImages(context),
              onAddVideo: () {},
              onMarkdownHelp: () {},
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Conditionally render the correct selector based on post type
                      if (state.postType == PostType.standard)
                        // Use the CommunitySelector widget for categories for a consistent UI
                        CommunitySelector(
                          selectedCommunityName:
                              state.selectedCategory?.name ?? 'Select Category',
                          onSelectCommunity: () => _selectCategory(context),
                        )
                      else
                        // Use the CommunitySelector for communities
                        CommunitySelector(
                          selectedCommunityName:
                              state.selectedCommunity?.name ??
                              'Select Community',
                          onSelectCommunity: () => _selectCommunity(context),
                        ),

                      const SizedBox(height: 20),
                      PostInputFields(
                        titleController: titleController,
                        bodyController: bodyController,
                        titleFocusNode: titleFocusNode,
                        bodyFocusNode: bodyFocusNode,
                        state: state,
                      ),
                      if (state.postType == PostType.poll)
                        PollEditorCard(
                          state: state,
                          onDurationSelected: () {
                            /* Add call to _selectPollDuration */
                          },
                        ),
                      if (state.locationAddress != null &&
                          state.locationAddress!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        LocationDisplay(address: state.locationAddress!),
                      ],
                      if (state.images.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        ImagePreview(images: state.images),
                      ],
                      if (state.postType != PostType.poll) ...[
                        const SizedBox(height: 26),
                        PostActionButtons(
                          state: state,
                          onFetchLocation: () {
                            _fetchLocation(context);
                          },
                          onCreateEvent:
                              () =>
                                  Navigator.pushNamed(context, '/create-event'),
                          onTagPeople: () {},
                        ),
                      ],
                      const SizedBox(height: 16),
                      PostSettings(state: state),
                    ],
                  ),
                ),
              ),
              if (state.showingTagSuggestions && state.filteredTags.isNotEmpty)
                TagSuggestionList(
                  tags: state.filteredTags,
                  onTagSelected: _onTagSelected,
                ),
            ],
          ),
        );
      },
    );
  }
}

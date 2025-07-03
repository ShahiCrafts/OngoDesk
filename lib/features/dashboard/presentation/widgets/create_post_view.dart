import 'dart:io'; // Required for File operations
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // Required for XFile
import 'package:ongo_desk/features/dashboard/presentation/view_model/mention_view_model.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/community_selector.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/post_body_field.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/post_bottom_toolbar.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/post_title_field.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/post_type.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/post_type_selector.dart';
import '../view_model/image_upload_event.dart';
import '../view_model/image_upload_state.dart';
import '../view_model/image_upload_view_model.dart';
import '../view_model/mention_event.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  PostType _selectedPostType = PostType.discussion;
  Community? _selectedCommunity;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _postBodyFocusNode = FocusNode();

  final List<Community> _communities = [
    const Community(
      name: 'og/roadmaintenance',
      members: '12,345 members',
      profileImageUrl: 'https://placehold.co/100x100/E91E63/FFFFFF?text=R',
    ),
    const Community(
      name: 'og/cleaningservices',
      members: '8,765 members',
      profileImageUrl: 'https://placehold.co/100x100/3F51B5/FFFFFF?text=C',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCommunity = _communities.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _postBodyFocusNode.dispose();
    super.dispose();
  }

  void _handleMentionUser() {
    final mentionBloc = context.read<MentionViewModel>();
    final currentText = _contentController.text;
    final selection = _contentController.selection;
    _postBodyFocusNode.requestFocus();
    final newText = currentText.replaceRange(selection.start, selection.end, '@');
    final newCursorPos = selection.start + 1;
    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(offset: newCursorPos);
    mentionBloc.add(MentionSymbolInserted(selection.start));
  }

  @override
  Widget build(BuildContext context) {
    // We use MultiBlocProvider to make multiple BLoCs available to the widget tree.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MentionViewModel()),
        BlocProvider(create: (_) => ImageUploadViewModel()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const CloseButton(color: Colors.black54),
          title: const SizedBox(),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5C00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        // A Builder is used here to ensure the context has access to the providers.
        body: Builder(builder: (context) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 72 + MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ... PostTypeCard GridView ...
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.8,
                      children: PostType.values.map((postType) {
                        return PostTypeCard(
                          postType: postType,
                          isSelected: _selectedPostType == postType,
                          onTap: () => setState(() => _selectedPostType = postType),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    const SizedBox(height: 16),
                    CommunitySelector(
                      communities: _communities,
                      selectedCommunity: _selectedCommunity,
                      onChanged: (value) => setState(() => _selectedCommunity = value),
                    ),
                    const SizedBox(height: 16),
                    // This BlocBuilder listens for image upload state changes.
                    BlocBuilder<ImageUploadViewModel, ImageUploadState>(
                      builder: (context, state) {
                        if (state is ImageUploadSuccess) {
                          // If images are selected, show the preview widget.
                          return _ImagePreview(images: state.selectedImages);
                        }
                        return const SizedBox.shrink(); // Otherwise, show nothing.
                      },
                    ),
                    PostTitleField(controller: _titleController),
                    PostBodyField(controller: _contentController),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: PostBottomToolbar(
                  onMentionUser: _handleMentionUser,
                  // The onAddImage callback now dispatches an event to the ImageUploadViewModel.
                  onAddImage: () {
                    context.read<ImageUploadViewModel>().add(ImagePermissionRequested());
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// A new widget to display selected images as a single preview or a carousel.
class _ImagePreview extends StatefulWidget {
  final List<XFile> images;
  const _ImagePreview({required this.images});

  @override
  State<_ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<_ImagePreview> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCarousel = widget.images.length > 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          // Display a carousel for multiple images
          if (isCarousel)
            Column(
              children: [
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(File(widget.images[index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Dot indicators for the carousel
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.images.length, (index) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey[300],
                      ),
                    );
                  }),
                ),
              ],
            )
          else // Display a single image
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: FileImage(File(widget.images.first.path)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // Close button to clear all selected images
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                context.read<ImageUploadViewModel>().add(ImageSelectionCleared());
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

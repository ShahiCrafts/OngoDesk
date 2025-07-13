import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../view_model/create_post_event.dart';
import '../../view_model/create_post_view_model.dart';

class ImagePreview extends StatefulWidget {
  final List<XFile> images;
  const ImagePreview({super.key, required this.images});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox.shrink();
    }
      
    return Container(
      height: 242,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(widget.images[index].path),
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Positioned(
            top: 8,
            right: 8,
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                final int currentIndex = (_pageController.hasClients && _pageController.page != null)
                    ? _pageController.page!.round()
                    : 0;

                if (currentIndex >= widget.images.length) {
                  return const SizedBox.shrink();
                }

                return _buildRemoveImageButton(context, widget.images[currentIndex]);
              },
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              top: 12,
              left: 12,
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  int currentPage =
                      (_pageController.hasClients && _pageController.page != null)
                          ? _pageController.page!.round() + 1
                          : 1;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$currentPage/${widget.images.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.images.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRemoveImageButton(BuildContext context, XFile imageToRemove) {
    return GestureDetector(
      onTap: () {
        final oldIndex = _pageController.page?.round() ?? 0;
        if (widget.images.length == 1) {
        } else if (oldIndex == widget.images.length - 1) {
          _pageController.jumpToPage(oldIndex - 1);
        }
        
        context.read<CreatePostViewModel>().add(ImageRemoved(imageToRemove));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(4),
        child: const Icon(Icons.close, color: Colors.white, size: 18),
      ),
    );
  }
}
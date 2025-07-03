import 'package:flutter/material.dart';

class DraggableToolbar extends StatelessWidget {
  final VoidCallback onTextTap;
  final VoidCallback onImageTap;

  const DraggableToolbar({
    super.key,
    required this.onTextTap,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.2,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: const Icon(Icons.text_fields), onPressed: onTextTap),
                  IconButton(icon: const Icon(Icons.photo_library), onPressed: onImageTap),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

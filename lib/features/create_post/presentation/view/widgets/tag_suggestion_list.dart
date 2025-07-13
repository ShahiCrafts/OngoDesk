import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';

class TagSuggestionList extends StatelessWidget {
  final List<TagEntity> tags;
  final Function(TagEntity) onTagSelected;

  const TagSuggestionList({
    super.key,
    required this.tags,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    // DEBUG: Print when the widget builds and how many tags it receives.
    if (kDebugMode) {
      print('[TagSuggestionList] Building with ${tags.length} tags.');
    }

    return Material(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return ListTile(
            title: Text('#${tag.name}'),
            subtitle: Text(
              tag.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text('${tag.issuesCount} posts'),
            onTap: () {
              // DEBUG: Print when a tag is tapped.
              if (kDebugMode) {
                print('[TagSuggestionList] Tapped on tag: #${tag.name}');
              }
              onTagSelected(tag);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          // MODIFIED: Adds 16 pixels of space on the left side.
          indent: 16,
          // MODIFIED: Adds 16 pixels of space on the right side.
          endIndent: 16,
          // MODIFIED: Sets the color to a light shade of grey.
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
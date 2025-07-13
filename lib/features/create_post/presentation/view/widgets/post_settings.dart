import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/create_post_event.dart';
import '../../view_model/create_post_state.dart';
import '../../view_model/create_post_view_model.dart';
import '../../view_model/post_type_enum.dart';

class PostSettings extends StatelessWidget {
  final CreatePostState state;
  const PostSettings({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state.postType != PostType.discussion)
          _buildToggleItem(
            context: context,
            title: 'Allow Comments',
            subtitle: 'Let others comment on this post.',
            value: state.allowComments,
            onTap: () =>
                context.read<CreatePostViewModel>().add(ToggleComments()),
          ),
        if (state.isPoll)
          _buildToggleItem(
            context: context,
            title: 'Allow Anonymous Voting',
            subtitle: 'Voters identities will be hidden.',
            value: state.allowAnonymousVoting,
            onTap: () => context
                .read<CreatePostViewModel>()
                .add(AnonymousVotingToggled()),
          ),
      ],
    );
  }

  Widget _buildToggleItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        const Divider(height: 24, thickness: 1, color: Color(0x15000000)),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: value,
                  activeColor: const Color(0xFFFF5C00),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (_) => onTap(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
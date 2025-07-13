import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/create_post_event.dart';
import '../../view_model/create_post_state.dart';
import '../../view_model/create_post_view_model.dart';
import '../../view_model/post_type_enum.dart';

class PollEditorCard extends StatelessWidget {
  final CreatePostState state;
  final VoidCallback onDurationSelected;

  const PollEditorCard({
    super.key,
    required this.state,
    required this.onDurationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 16, right: 48),
                title: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Poll ends in ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text:
                            '${state.pollEndDays} day${state.pollEndDays > 1 ? 's' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: onDurationSelected,
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    ...state.pollOptions.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String val = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: val,
                                onChanged: (text) => context
                                    .read<CreatePostViewModel>()
                                    .add(PollOptionChanged(idx, text)),
                                decoration: InputDecoration(
                                  hintText: 'Option ${idx + 1}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                            if (state.pollOptions.length > 2)
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                                onPressed: () => context
                                    .read<CreatePostViewModel>()
                                    .add(PollOptionRemoved(idx)),
                              ),
                          ],
                        ),
                      );
                    }),
                    if (state.pollOptions.length < 6)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Option'),
                          onPressed: () => context
                              .read<CreatePostViewModel>()
                              .add(PollOptionAdded()),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: Icon(Icons.cancel, color: Colors.grey.shade400),
              onPressed: () => context
                  .read<CreatePostViewModel>()
                  .add(const PostTypeChanged(PostType.standard)),
            ),
          ),
        ],
      ),
    );
  }
}
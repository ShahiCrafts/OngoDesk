import 'package:flutter/material.dart';

class CommunityDrawer extends StatelessWidget {
  final bool isListOpen;
  final VoidCallback toggleList;
  final List<Map<String, dynamic>> communities;

  const CommunityDrawer({
    super.key,
    required this.isListOpen,
    required this.toggleList,
    required this.communities,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(),
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          SizedBox(
            height: 60,
            child: GestureDetector(
              onTap: toggleList,
              child: DrawerHeader(
                child: Row(
                  children: [
                    const Text(
                      'Your Communities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isListOpen
                          ? Icons.arrow_drop_down_rounded
                          : Icons.arrow_right_rounded,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
          isListOpen
              ? Column(
                children:
                    communities.map((value) {
                      return ListTile(
                        title: Text(
                          value['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black54,
                          child: Icon(value['icon'], size: 18),
                        ),
                        trailing: Icon(
                          value['isFavorite']
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                        ),
                      );
                    }).toList(),
              )
              : const Padding(
                padding: EdgeInsets.only(left: 20, top: 14),
                child: Row(
                  children: [
                    Icon(Icons.manage_search),
                    SizedBox(width: 8),
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

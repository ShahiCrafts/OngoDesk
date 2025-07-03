import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<PopupMenuButtonState> popupKey;
  final VoidCallback onProfileLongPress;
  final VoidCallback onProfilePressed;

  const DashboardAppBar({
    super.key,
    required this.scaffoldKey,
    required this.popupKey,
    required this.onProfileLongPress,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFFFF5C00);

    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: Image.asset('assets/icons/menu.png'),
        ),
      ),
      title: Row(
        children: const [
          Text(
            '.OnGo Desk',
            style: TextStyle(
              color: brandColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: Colors.black87, size: 20),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: const [
                    Icon(Icons.notifications),
                    Positioned(
                      top: -3,
                      right: -4,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 7,
                        child: Text(
                          '3',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              
              PopupMenuButton<String>(
                  key: popupKey,
                  position: PopupMenuPosition.under,
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 'logout') {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },

                  tooltip: 'Popup Menu',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings, size: 18),
                              SizedBox(width: 8),
                              Text('Settings'),
                            ],
                          ),
                        ),

                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 18),
                              SizedBox(width: 8),
                              Text('Logout'),
                            ],
                          ),
                        ),
                      ],
                  child: GestureDetector(
                    onLongPress: onProfileLongPress,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: onProfilePressed,
                          icon: CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFFFF5C00),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    
                        Positioned(
                          bottom: 3,
                          right: 3,
                          child: Container(
                            height: 20,
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                    
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                    
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

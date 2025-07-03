import 'package:flutter/material.dart';

class ProfileOptionsBottomSheet extends StatelessWidget {
  final String accountName;

  const ProfileOptionsBottomSheet({
    super.key,
    this.accountName = 'Saugat Shahi',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 60,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const Text(
              'Accounts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),
            const Divider(),

            ListTile(
              leading: const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFFF5C00),
                child: Icon(Icons.person, color: Colors.white, size: 16,),
              ),
              title: Text(accountName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              trailing: IconButton(
                icon: const Icon(Icons.logout, size: 20,),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              onTap: () {},
            ),

            ListTile(
              leading: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey,
                child: Icon(Icons.health_and_safety,  color: Colors.white, size: 16,),
              ),
              title: const Text('Anonymous Browsing'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.black87,
                child: Icon(Icons.add, color: Colors.white, size: 16,),
              ),
              title: const Text('Add another account'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

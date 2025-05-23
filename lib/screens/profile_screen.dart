import 'package:flutter/material.dart';
import '../components/menuitem.dart';

class ProfileScreen extends StatelessWidget {
  final String courierName;

  const ProfileScreen({super.key, this.courierName = "Nama Kurir"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [

                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    Icons.delivery_dining,
                    size: 48,
                    color: Colors.blue.shade700,
                  ),
                ),

                const SizedBox(width: 20),

                // Courier name and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        courierName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Kurir Pengantar Paket',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Logout menu item
            MenuItem(
              icon: Icons.logout,
              text: 'Logout',
              iconColor: Colors.red,
              onTap: () {
                // TODO: implement logout logic, contoh:
                // TokenManager.removeToken();
                // Navigator.pushReplacementNamed(context, '/login');
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Apakah Anda yakin ingin logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Lakukan logout
                              Navigator.pop(context);
                              // Contoh: hapus token dan pindah ke login
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/app/data/profile_response.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<ProfileResponse>(
            future: controller.profileFuture,
            builder: (context, snapshot) {
              // Loading State
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.network(
                        'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                      const SizedBox(height: 20),
                      const Text('Loading profile...'),
                    ],
                  ),
                );
              }

              // Error State
              if (snapshot.hasError || snapshot.data?.data == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      "Failed to load profile data",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Try Again"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        controller.profileFuture = controller.getProfile();
                        (context as Element).reassemble();
                      },
                    ),
                  ],
                );
              }

              // Success State
              final profile = snapshot.data!.data!;
              final joinDate = profile.createdAt != null 
                  ? DateTime.parse(profile.createdAt!)
                  : DateTime.now();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Picture Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Profile Info Section
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Name
                            _buildProfileItem(
                              icon: Icons.person_outline,
                              label: 'Name',
                              value: profile.name ?? 'Not set',
                            ),
                            const Divider(height: 30),

                            // Email
                            _buildProfileItem(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: profile.email ?? 'Not set',
                            ),
                            const Divider(height: 30),

                            // User ID
                            _buildProfileItem(
                              icon: Icons.perm_identity,
                              label: 'User ID',
                              value: profile.id?.toString() ?? 'N/A',
                            ),
                            const Divider(height: 30),

                            // Account Type
                            _buildProfileItem(
                              icon: Icons.admin_panel_settings_outlined,
                              label: 'Account Type',
                              value: profile.isAdmin == 1 ? 'Administrator' : 'Regular User',
                            ),
                            const Divider(height: 30),

                            // Join Date
                            _buildProfileItem(
                              icon: Icons.calendar_today_outlined,
                              label: 'Member Since',
                              value: '${joinDate.day}/${joinDate.month}/${joinDate.year}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Edit Profile Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Add edit profile functionality
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper Widget for Profile Items
  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
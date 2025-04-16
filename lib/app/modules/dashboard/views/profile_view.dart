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
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<ProfileResponse>(
            future: controller.profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.network(
                    'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                    width: MediaQuery.of(context).size.width / 1.5,
                  ),
                );
              }

              if (snapshot.hasError || snapshot.data?.data == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Failed to load profile"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.profileFuture = controller.getProfile();
                        (context as Element).reassemble(); // rebuild the widget tree
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                );
              }

              final profile = snapshot.data!.data!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${profile.name}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("${profile.email}"),
                  const SizedBox(height: 8),
                  Text("ID: ${profile.id}"),
                  const SizedBox(height: 8),
                  Text("Admin: ${profile.isAdmin == 1 ? "Yes" : "No"}"),
                  const SizedBox(height: 8),
                  Text("Joined: ${profile.createdAt}"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

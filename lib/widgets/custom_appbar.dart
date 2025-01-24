import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_x/providers/profile_provider.dart';
import 'package:product_x/screens/profile_screen.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showProfile;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showProfile = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    return AppBar(
      title: Text(title),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: showProfile,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundImage: profileState.profileImagePath != null
                      ? FileImage(File(profileState.profileImagePath!))
                      : null,
                  child: profileState.profileImagePath == null
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
              )),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

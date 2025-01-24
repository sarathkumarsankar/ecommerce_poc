import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_x/providers/auth_provider.dart';
import 'package:product_x/providers/profile_provider.dart';
import 'package:product_x/screens/login_screen.dart';
import 'registration_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  static const platform = MethodChannel('com.example/device_info');
  String deviceInfo = 'Fetching device info...';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initializeControllers();
    fetchDeviceInfo();
  }

  void initializeControllers() {
    final profileState = ref.read(profileProvider);
    final authState = ref.read(authProvider);
    nameController = TextEditingController(text: profileState.name ?? 'Sarath');
    emailController = TextEditingController(text: authState.email ?? 'Unknown');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> fetchDeviceInfo() async {
    try {
      final result = await platform.invokeMethod<Map<dynamic, dynamic>>('getDeviceInfo');
      if (result != null) {
        setState(() {
          deviceInfo =
              'Model: ${result['modelName']}\nSystem: ${result['systemName']} ${result['systemVersion']}';
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        deviceInfo = 'Failed to fetch device info: ${e.message}';
      });
    }
  }

  Future<void> _pickImage(ImageSource source, String userId) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 400,
      maxHeight: 400,
    );

    if (pickedFile != null) {
      ref.read(profileProvider.notifier).updateProfileImage(
            path: pickedFile.path,
            userId: userId,
          );
      _showSnackBar('Profile picture updated!');
    }
  }

  void _showSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _logout() async {
    ref.read(authProvider.notifier).logout();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  Future<void> _saveChanges(String userId) async {
    ref.read(profileProvider.notifier).updateName(
          name: nameController.text,
          userId: userId,
        );
    _showSnackBar('Profile updated!');
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final authState = ref.watch(authProvider);
    final profileNotifier = ref.read(profileProvider.notifier);
    profileNotifier.loadProfileData(authState.userId ?? "");
    nameController = TextEditingController(text: profileState.name ?? 'Sarath');

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileImage(profileState, authState.userId ?? ""),
            const SizedBox(height: 16),
            _buildTextField(
              controller: nameController,
              label: 'Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _saveChanges(authState.userId ?? ""),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                deviceInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Profile'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _logout,
        ),
      ],
    );
  }

  Widget _buildProfileImage(ProfileState profileState, String userId) {
    return GestureDetector(
      onTap: () => _pickImage(ImageSource.gallery, userId),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: profileState.profileImagePath != null
            ? FileImage(File(profileState.profileImagePath!))
            : null,
        child: profileState.profileImagePath == null
            ? const Icon(Icons.person, size: 60, color: Colors.grey)
            : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: Icon(icon),
      ),
    );
  }
}

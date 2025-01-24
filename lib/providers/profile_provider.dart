import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileState {
  final String? profileImagePath;
  final String? name;

  ProfileState({this.profileImagePath, this.name});

  ProfileState copyWith({String? profileImagePath, String? name}) {
    return ProfileState(
      profileImagePath: profileImagePath ?? this.profileImagePath,
      name: name ?? this.name,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState()) { }

  Future<void> loadProfileData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final profileImagePath = prefs.getString('profileImagePath_$userId');
    final name = prefs.getString('profileName_$userId');

    state = ProfileState(
      profileImagePath: profileImagePath,
      name: name,
    );
  }

  Future<void> updateProfileImage({required String path, required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath_$userId', path);

    state = state.copyWith(profileImagePath: path);
  }

  Future<void> updateName({required String name, required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileName_$userId', name);
    state = state.copyWith(name: name);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);

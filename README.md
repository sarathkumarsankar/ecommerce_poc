

## Instructions:

### Clone or Download the Project:

git clone [repository-url]

cd product_flutter-main

### Install Dependencies:
flutter pub get

### Check Platform Support: Confirm that both iOS and Android are supported:
flutter doctor

### run
flutter run

## App Instructions:
- First-Time Launch: The app will display the Login screen.
- Sign Up: Tap the Sign Up button to navigate to the Registration screen. Enter a valid email, password, and name.
- Account Creation: After pressing Sign Up, the app will redirect you back to the Login screen.
- Log In: On the Login screen, enter the registered email and password, then tap Log In to proceed to the Product List screen.
- On the Product List screen, tap a product to view its details on the Product Detail screen.
- Profile Screen: appbar, tap the Profile icon in the top-right corner to access the Profile screen where you can update your details.
------------------ ------------------

# Screenshots:
![Simulator Screenshot - iPhone 15 Pro - 2025-01-24 at 13 16 30](https://github.com/user-attachments/assets/67f332e5-b9b5-4fb6-b5a3-cc4ba99fdd20)
![Simulator Screenshot - iPhone 15 Pro - 2025-01-24 at 13 16 33](https://github.com/user-attachments/assets/cd93bba1-a073-4412-9fad-e02897b1c6d9)

## Design Choices
### 1. State Management with Riverpod

  We chose Riverpod for state management due to its simplicity, reactivity, and compile-time safety. Riverpod's architecture makes the app modular and testable while avoiding context-related     issues.
  ConsumerWidget and StateNotifierProvider were used to manage and update user profile and authentication states effectively.
  
### 2. Image Handling with ImagePicker

  The ImagePicker package was used for selecting profile images from the gallery, offering a straightforward API and compatibility with both iOS and Android platforms.
  Image resizing was implemented to ensure the app handles images efficiently, reducing potential memory issues on lower-end devices.
  
### 3. Data Persistence with SharedPreferences

To persist user profile information (image path and name) across app launches, SharedPreferences was used. It is lightweight, easy to implement, and ideal for storing simple key-value pairs.
UI/UX Design.  


### 4. Error Handling and Feedback

Snackbars provide users with real-time feedback for actions like updating profile information or toggling favorites.
Error widgets (e.g., for failed image loading) ensure the app remains user-friendly even in failure scenarios.

## Challenges Faced
1. Managing persistence with SharedPreferences required carefully integrating async operations into the state notifier to ensure data loading did not block the UI.
Platform-Specific Behaviors

2. cloud_firestore package taking long time to build ios app, hence i ignored, instead used shared proferrence to persist user specif data.






## Design Choices
### 1. State Management with Riverpod

  We chose Riverpod for state management due to its simplicity, reactivity, and compile-time safety. Riverpod's architecture makes the app modular and testable while avoiding context-related     issues.
  ConsumerWidget and StateNotifierProvider were used to manage and update user profile and authentication states effectively.
  
### 2. Image Handling with ImagePicker

  The ImagePicker package was used for selecting profile images from the gallery, offering a straightforward API and compatibility with both iOS and Android platforms.
  Image resizing was implemented to ensure the app handles images efficiently, reducing potential memory issues on lower-end devices.
  
### 3. Data Persistence with SharedPreferences

To persist user profile information (image path and name) across app launches, SharedPreferences was used. It is lightweight, easy to implement, and ideal for storing simple key-value pairs.
UI/UX Design

A clean and responsive UI was implemented using Flutter’s Material Design components. Input fields and buttons were styled for better usability and consistency across devices.
Dynamic layouts, such as grid and single-column views, adapt based on screen size for a seamless user experience.

### 4. Error Handling and Feedback

Snackbars provide users with real-time feedback for actions like updating profile information or toggling favorites.
Error widgets (e.g., for failed image loading) ensure the app remains user-friendly even in failure scenarios.

## Challenges Faced
1. Managing persistence with SharedPreferences required carefully integrating async operations into the state notifier to ensure data loading did not block the UI.
Platform-Specific Behaviors

2. Designing responsive layouts for both mobile and tablet screens added complexity to the UI design. Utilizing MediaQuery and dynamic grid configurations resolved this issue.
Efficient Image Handling


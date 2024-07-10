# Collaborative Notes App

Collaborative Notes is a real-time collaborative notes application built with Flutter. This app allows multiple users to view and edit notes simultaneously, with user avatars displayed in a circular shape with random colors. The app also includes features such as user authentication, note creation, editing, and deletion, and displays a list of active users with their roles (viewing or editing).

## Features

- **User Authentication**: Users can log in with a username.
- **Real-Time Collaboration**: Multiple users can view and edit notes simultaneously.
- **User Avatars**: Active users are displayed with their initials in a circular avatar with a random color.
- **Role Indicators**: Editing users' avatars have an orange border.
- **Note Management**: Users can create, edit, and delete notes.
- **Swipe to Delete**: Users can delete notes by swiping them in the list.
- **Persistent Login**: The app remembers the last logged-in user and directly navigates to the notes list screen if the username is saved.
- **Firebase Integration**: The app uses Firestore for storing notes and active users.

## Example Video

Here is a quick demonstration of the app in action:
![Example Video](https://drive.google.com/uc?id=1um2DNtrMLlH_vFrozU5ImOFQt0qpv2Yz/preview)

## Screens

1. **Login Screen**: Allows users to log in with a username.
2. **Notes List Screen**: Displays a list of notes with the option to add a new note.
3. **Note Editor Screen**: Allows users to create or edit a note. Displays a list of active users and their roles.

## Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/your-repo/collaborative_notes_app.git
    cd collaborative_notes_app
    ```

2. **Install dependencies**:
    ```sh
    flutter pub get
    ```

3. **Configure Firebase**:
    - Create a Firebase project and Firestore database.
    - Add your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files to the project.

4. **Run the app**:
    ```sh
    flutter run
    ```

## Code Structure

```plaintext
lib/
|-- blocs/
|   |-- note/
|   |   |-- note_bloc.dart
|   |   |-- note_event.dart
|   |   `-- note_state.dart
|-- models/
|   |-- note_model.dart
|   `-- user_model.dart
|-- repositories/
|   `-- note_repository.dart
|-- screens/
|   |-- login_screen.dart
|   |-- note_list_screen.dart
|   |-- note_editor_screen.dart
|   `-- add_note_screen.dart
|-- utils/
|   `-- colors.dart
|-- main.dart
```

### Detailed Code

## Note List Screen

The Note List Screen displays all notes for the user.

- **Fetch Notes**: The screen fetches and displays a list of notes when it loads.
- **No Notes Available**: If there are no notes, a message and a button to create a new note are displayed.
- **Create New Note**: The floating action button at the bottom right allows users to create a new note.
- **Swipe to Delete**: Users can swipe left or right on a note to delete it.
- **Edit Note**: Tapping on a note navigates to the Note Editor screen to edit the note.
- **Logout**: The logout button in the app bar allows users to log out and return to the login screen.

## Note Editor Screen

The Note Editor Screen allows users to create or edit notes. It also displays a list of active users with their roles.

- **Real-Time Editing**: As users type, their role changes to 'editing'. When they stop typing for a specified duration, their role changes back to 'viewing'.
- **User Avatars**: Active users' initials are displayed in circular avatars with random colors. Editing users' avatars have an orange border.
- **Save Note**: Users can save their changes and return to the notes list.

## Bloc Structure

The application follows the Bloc (Business Logic Component) pattern to manage state.

### Note Bloc

The `NoteBloc` handles the following events:
- `LoadNotes`: Fetches the list of notes from the repository.
- `AddNote`: Adds a new note to the repository.
- `UpdateNote`: Updates an existing note in the repository.
- `DeleteNote`: Deletes a note from the repository.
- `LoadActiveUsers`: Fetches the list of active users for a note.
- `AddUserToActiveUsers`: Adds a user to the active users list.
- `UpdateUserRole`: Updates a user's role (viewing/editing).
- `RemoveUserFromActiveUsers`: Removes a user from the active users list.

### Note Repository

The `NoteRepository` interface with Firestore to perform CRUD operations and manage active users.

### Note Model

The `Note` model represents the structure of a note, including its content, author, and timestamp.

### User Model

The `UserModel` represents an active user, including their username, role, and avatar color.

## Firebase Setup

Ensure you have Firebase set up for your Flutter project. Follow these steps:

1. Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/).
2. Add an Android and iOS app to your Firebase project.
3. Download the `google-services.json` file for Android and `GoogleService-Info.plist` file for iOS.
4. Place these files in the appropriate directories of your Flutter project:
    - `android/app` for `google-services.json`
    - `ios/Runner` for `GoogleService-Info.plist`
5. Modify your Android and iOS build files to include Firebase configurations.

## Running the App

1. **Clone the repository**:
    ```sh
    git clone https://github.com/your-repo/collaborative_notes_app.git
    cd collaborative_notes_app
    ```

2. **Install dependencies**:
    ```sh
    flutter pub get
    ```

3. **Configure Firebase**:
    - Follow the Firebase setup steps mentioned above.

4. **Run the app**:
    ```sh
    flutter run
    ```

## Usage

1. **Login**: Enter a username to log in.
2. **Notes List**: View a list of notes. Add a new note using the floating action button.
3. **Edit Note**: Tap on a note to edit it. You can see other active users editing or viewing the note.
4. **Swipe to Delete**: Swipe a note to delete it.
5. **Logout**: Use the logout button in the app bar to log out.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any features, bug fixes, or improvements.

## License

This project is licensed under the MIT License. See the LICENSE file for details.



import 'package:collaborative_notes_app/screens/note_list_screen.dart';
import 'package:collaborative_notes_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blocs/note/note_bloc.dart';
import 'repositories/note_repository.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CollaborativeNotesApp());
}

class CollaborativeNotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NoteBloc(noteRepository: NoteRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Collaborative Notes',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.black,
          // primaryColor: AppColors.primary,
          colorSchemeSeed: AppColors.primary,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',

          textTheme: ThemeData.light().textTheme.apply(
                bodyColor: AppColors.white,
                displayColor: AppColors.white,
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.primary),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(AppColors.primary),
            ),
          ),
          iconTheme: IconThemeData(color: AppColors.white),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.black,
            iconTheme: IconThemeData(color: AppColors.white),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.primary,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColors.black,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.white,
          ),
          cardColor: AppColors.blackShade2,
        ),
        home: FutureBuilder(
          future: _checkUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                // Username exists, navigate to NoteListScreen
                return NoteListScreen(username: snapshot.data!);
              } else {
                // Username doesn't exist, navigate to LoginScreen
                return LoginScreen();
              }
            }
          },
        ),
      ),
    );
  }

  Future<String?> _checkUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}

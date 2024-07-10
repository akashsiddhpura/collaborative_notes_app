import 'package:collaborative_notes_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_list_screen.dart'; // Assuming this is where the user navigates after login

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                alignment: Alignment.centerLeft,
                child: Text(
                  "A collaborative note taking app, \nmade with Flutter",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white.withOpacity(.5),
                  ),
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Enter Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                child: Container(
                  width: 200,
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      // Save username to local storage (SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      // Navigate to NoteListScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NoteListScreen(username: username),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter a username.'),
          titleTextStyle: TextStyle(color: AppColors.blackShade1, fontWeight: FontWeight.bold, fontSize: 20),
          contentTextStyle: TextStyle(color: AppColors.blackShade2, fontWeight: FontWeight.w400, fontSize: 16),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

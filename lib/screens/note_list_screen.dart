import 'package:collaborative_notes_app/screens/add_note_screen.dart';
import 'package:collaborative_notes_app/screens/login_screen.dart';
import 'package:collaborative_notes_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/note/note_bloc.dart';
import '../blocs/note/note_event.dart';
import '../blocs/note/note_state.dart';
import '../models/note_model.dart';
import 'note_editor_screen.dart';

class NoteListScreen extends StatefulWidget {
  final String username;

  NoteListScreen({required this.username});

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  String? userName;
  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadNotes();
  }

  void _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username');
    });
  }

  void _loadNotes() {
    // Dispatch LoadNotes event to fetch notes
    context.read<NoteBloc>().add(LoadNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(.4),
            radius: 10,
            child: Text(
              userName?.substring(0, 1) ?? '',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),
        title: Text(
          '${userName ?? 'Collaborative Notes'}',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Clear username from SharedPreferences on logout
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())); // Navigate back to login screen
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NoteLoaded) {
            if (state.notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No notes available.'),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _navigateToNoteEditor(context);
                      },
                      child: Text('Create New Note'),
                    ),
                  ],
                ),
              );
            } else {
              return _buildNoteList(state.notes); // Display the list of notes
            }
          } else if (state is NoteError) {
            return Center(child: Text(state.error));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNoteEditor(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteList(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return noteCard(context, note);
      },
    );
  }

  void _navigateToNoteEditor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(username: widget.username),
      ),
    ).then((_) {
      // Refresh notes after returning from NoteEditorScreen (optional)
      _loadNotes();
    });
  }

  Widget noteCard(BuildContext context, Note note) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Dismissible(
          key: Key(note.id),
          onDismissed: (direction) {
            // Dispatch DeleteNote event to delete the note
            context.read<NoteBloc>().add(DeleteNote(noteId: note.id));
          },
          // Show a red background as the item is swiped away.
          background: Container(color: Colors.red),

          child: ListTile(
            title: Text(note.content),
            subtitle: Text('By: ${note.username}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoteEditorScreen(username: widget.username, noteId: note.id)),
              ).then((_) {
                // Refresh notes after returning from NoteEditorScreen (optional)

                Future.delayed(Duration(milliseconds: 500), () {
                  if (mounted) {
                    _loadNotes();
                  }
                });
              });
            },
          ),
        ),
      ),
    );
  }
}

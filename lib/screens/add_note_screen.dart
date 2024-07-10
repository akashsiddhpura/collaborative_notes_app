import 'package:collaborative_notes_app/blocs/note/note_event.dart';
import 'package:collaborative_notes_app/blocs/note/note_state.dart';
import 'package:collaborative_notes_app/models/note_model.dart';
import 'package:collaborative_notes_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/note/note_bloc.dart';
import '../utils/colors.dart';

class AddNoteScreen extends StatefulWidget {
  final String username;

  AddNoteScreen({required this.username});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _contentController = TextEditingController();
  late NoteBloc _noteBloc;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _noteBloc = context.read<NoteBloc>();
  }

  void _saveNote() {
    // Save the note content in Firestore
    if(_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a note content'),
        ),
      );
      return;
    }
    final note = Note(
      id: "${DateTime.now().millisecondsSinceEpoch}",
      content: _contentController.text,
      username: widget.username,
    );
    _noteBloc.add(AddNote(note: note));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Note',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _contentController,
              maxLines: 8,

              decoration: InputDecoration(
                fillColor: AppColors.blackShade1,
                filled: true,
                hintText: 'Enter your note content here...',
                hintStyle: TextStyle(color: AppColors.grey),

              ),

              // onChanged: _onTextChanged,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28.0),
              child: ElevatedButton(
                onPressed: _saveNote,
                child: Container(
                  width: 200,
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    'Save Note',
                    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(List<UserModel> users) {
    return Row(
      children: users.take(3).map((user) {
        return SizedBox(
          child: CircleAvatar(
            backgroundColor: Color(int.parse(user.color)),
            child: Text(user.username[0]),
          ),
        );
      }).toList()
        ..add(users.length > 3 ? SizedBox(child: Text('+${users.length - 3}', style: TextStyle(color: Colors.black))) : const SizedBox()),
    );
  }

  Widget _buildUserDropdown(List<UserModel> users) {
    return DropdownButton(
      icon: Icon(Icons.arrow_drop_down),
      items: users.map((user) {
        return DropdownMenuItem(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(int.parse(user.color)),
                child: Text(user.username[0]),
              ),
              SizedBox(width: 8),
              Text(user.username),
              SizedBox(width: 8),
              Icon(user.role == 'editing' ? Icons.edit : Icons.remove_red_eye),
            ],
          ),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }

  int _generateRandomColor() {
    return Colors.primaries[widget.username.codeUnitAt(0) % Colors.primaries.length].value;
  }
}

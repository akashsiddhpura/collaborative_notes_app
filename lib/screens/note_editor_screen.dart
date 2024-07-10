import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_notes_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note/note_bloc.dart';
import '../blocs/note/note_event.dart';
import '../blocs/note/note_state.dart';
import '../models/note_model.dart';
import '../models/user_model.dart';

class NoteEditorScreen extends StatefulWidget {
  final String username;
  final String noteId;

  NoteEditorScreen({required this.username, required this.noteId});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final TextEditingController _contentController = TextEditingController();
  final CollectionReference _notesCollection = FirebaseFirestore.instance.collection('notes');
  late CollectionReference _activeUsersCollection;
  Timer? _typingTimer;
  final Duration _typingTimeout = const Duration(seconds: 5);
  late String _userColor;

  @override
  void initState() {
    super.initState();
    _userColor = _generateRandomColor();
    _activeUsersCollection = _notesCollection.doc(widget.noteId).collection('activeUsers');

    _notesCollection.doc(widget.noteId).get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          _contentController.text = snapshot['content'];
        });
      }
    });
    _addUserToActiveUsers('viewing');
    context.read<NoteBloc>().add(LoadActiveUsers(noteId: widget.noteId));
  }

  @override
  void dispose() {
    _removeUserFromActiveUsers();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _addUserToActiveUsers(String role) {
    _activeUsersCollection.doc(widget.username).set({
      'username': widget.username,
      'role': role,
      'color': _userColor,
    });
  }

  void _updateUserRole(String role) {
    _activeUsersCollection.doc(widget.username).update({
      'role': role,
    });
  }

  void _removeUserFromActiveUsers() {
    _activeUsersCollection.doc(widget.username).delete();
  }

  void _saveNote() {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a note content'),
        ),
      );
      return;
    }
    _notesCollection.doc(widget.noteId).update({'content': _contentController.text});
    Navigator.pop(context);
  }

  void _onTextChanged() {
    if (_typingTimer?.isActive ?? false) _typingTimer?.cancel();
    _updateUserRole('editing');
    _typingTimer = Timer(_typingTimeout, () {
      _updateUserRole('viewing');
    });
  }

  String _generateRandomColor() {
    final List<String> colors = ['0xFFB71C1C', '0xFFD32F2F', '0xFF880E4F', '0xFFEC407A', '0xFF4A148C', '0xFF9575CD', '0xFF1A237E', '0xFF2196F3', '0xFF004D40', '0xFF00796B', '0xFF2E7D32', '0xFF33691E', '0xFFF57F17', '0xFFFF6F00', '0xFFE65100'];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }

  Widget _buildUserAvatar(String initial, int colorHex, bool isEdit) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: isEdit ? AppColors.primary : Colors.transparent, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          backgroundColor: Color(colorHex),
          child: Text(
            initial.toLowerCase(),
            style: const TextStyle(color: AppColors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(List<UserModel> users) {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: users.map((user) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Visibility(visible: user.username != widget.username, child: _buildUserAvatar(user.username.substring(0, 1), int.parse(user.color), user.role == 'editing')),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Note',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<NoteBloc>().add(DeleteNote(noteId: widget.noteId));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: const InputDecoration(
                fillColor: AppColors.blackShade1,
                filled: true,
                hintText: 'Enter your note content here...',
                hintStyle: TextStyle(color: AppColors.grey),
              ),
              onChanged: (_) => _onTextChanged(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28.0),
              child: ElevatedButton(
                onPressed: _saveNote,
                child: Container(
                  width: 200,
                  height: 60,
                  alignment: Alignment.center,
                  child: const Text(
                    'Edit Note',
                    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Active Users',
                style: TextStyle(color: AppColors.white),
              ),
            ),
            BlocBuilder<NoteBloc, NoteState>(
              bloc: BlocProvider.of<NoteBloc>(context),
              builder: (context, state) {
                if (state is ActiveUsersLoaded) {
                  final users = state.activeUsers;
                  return _buildUserList(users);
                }
                return Container(
                  child: Text('Unknown state: ${state.runtimeType}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';
import '../models/user_model.dart';

class NoteRepository {
  final CollectionReference _notesCollection =
  FirebaseFirestore.instance.collection('notes');

  Stream<List<Note>> getNotes() {
    return _notesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> addNote(Note note) {
    return _notesCollection.add(note.toMap());
  }

  Future<void> updateNote(Note note) {
    return _notesCollection.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String id) {
    return _notesCollection.doc(id).delete();
  }

  Stream<List<UserModel>> getActiveUsers(String noteId) {
    return _notesCollection
        .doc(noteId)
        .collection('activeUsers')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel(
          username: data['username'],
          role: data['role'],
          color: data['color'],
        );
      }).toList();
    });
  }

  Future<void> addUserToActiveUsers(String noteId, UserModel user) {
    return _notesCollection
        .doc(noteId)
        .collection('activeUsers')
        .doc(user.username)
        .set({
      'username': user.username,
      'role': user.role,
      'color': user.color,
    });
  }

  Future<void> updateUserRole(String noteId, UserModel user) {
    return _notesCollection
        .doc(noteId)
        .collection('activeUsers')
        .doc(user.username)
        .update({
      'role': user.role,
    });
  }

  Future<void> removeUserFromActiveUsers(String noteId, String username) {
    return _notesCollection
        .doc(noteId)
        .collection('activeUsers')
        .doc(username)
        .delete();
  }
}

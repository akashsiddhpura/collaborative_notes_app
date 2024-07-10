import 'package:equatable/equatable.dart';
import '../../models/note_model.dart';
import '../../models/user_model.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {}



class AddNote extends NoteEvent {
  final Note note;

  AddNote({required this.note});

  @override
  List<Object?> get props => [note];
}

class UpdateNote extends NoteEvent {
  final Note note;

  UpdateNote({required this.note});

  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NoteEvent {
  final String noteId;

  DeleteNote({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

class LoadActiveUsers extends NoteEvent {
  final String noteId;

  LoadActiveUsers({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

class AddUserToActiveUsers extends NoteEvent {
  final String noteId;
  final UserModel user;

  AddUserToActiveUsers({required this.noteId, required this.user});

  @override
  List<Object?> get props => [noteId, user];
}

class UpdateUserRole extends NoteEvent {
  final String noteId;
  final UserModel user;

  UpdateUserRole({required this.noteId, required this.user});

  @override
  List<Object?> get props => [noteId, user];
}

class RemoveUserFromActiveUsers extends NoteEvent {
  final String noteId;
  final String username;

  RemoveUserFromActiveUsers({required this.noteId, required this.username});

  @override
  List<Object?> get props => [noteId, username];
}

import 'package:equatable/equatable.dart';
import '../../models/note_model.dart';
import '../../models/user_model.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;

  const NoteLoaded({required this.notes});

  @override
  List<Object?> get props => [notes];
}

class NoteError extends NoteState {
  final String error;

  const NoteError({required this.error});

  @override
  List<Object?> get props => [error];
}

class ActiveUsersLoaded extends NoteState {
  final List<UserModel> activeUsers;

  const ActiveUsersLoaded({required this.activeUsers});

  @override
  List<Object?> get props => [activeUsers];
}

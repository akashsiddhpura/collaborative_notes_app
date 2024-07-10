import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../../repositories/note_repository.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;

  NoteBloc({required this.noteRepository}) : super(NoteLoading()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
    on<LoadActiveUsers>(_onLoadActiveUsers);
    on<AddUserToActiveUsers>(_onAddUserToActiveUsers);
    on<UpdateUserRole>(_onUpdateUserRole);
    on<RemoveUserFromActiveUsers>(_onRemoveUserFromActiveUsers);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    await emit.forEach(
      noteRepository.getNotes(),
      onData: (eventRes) {
        return eventRes.fold(const NoteLoaded(notes: []), (t, notes) => NoteLoaded(notes: eventRes));
      },
    );
  }

  void _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    await noteRepository.addNote(event.note);
  }

  void _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    await noteRepository.updateNote(event.note);
  }

  void _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    await noteRepository.deleteNote(event.noteId);
  }

  Future<void> _onLoadActiveUsers(LoadActiveUsers event, Emitter<NoteState> emit) async {
    await emit.forEach(
      noteRepository.getActiveUsers(event.noteId),
      onData: (activeUsers) {
        return activeUsers.fold(
          const ActiveUsersLoaded(activeUsers: []),
          (t, notes) => ActiveUsersLoaded(activeUsers: activeUsers),
        );
      },
    );
  }

  void _onAddUserToActiveUsers(AddUserToActiveUsers event, Emitter<NoteState> emit) async {
    await noteRepository.addUserToActiveUsers(event.noteId, event.user);
  }

  void _onUpdateUserRole(UpdateUserRole event, Emitter<NoteState> emit) async {
    await noteRepository.updateUserRole(event.noteId, event.user);
  }

  void _onRemoveUserFromActiveUsers(RemoveUserFromActiveUsers event, Emitter<NoteState> emit) async {
    await noteRepository.removeUserFromActiveUsers(event.noteId, event.username);
  }
}

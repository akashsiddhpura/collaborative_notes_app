import 'package:collaborative_notes_app/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:collaborative_notes_app/blocs/note/note_bloc.dart';
import 'package:collaborative_notes_app/blocs/note/note_event.dart';
import 'package:collaborative_notes_app/blocs/note/note_state.dart';
import 'package:collaborative_notes_app/models/note_model.dart';
import 'package:collaborative_notes_app/repositories/note_repository.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late NoteBloc noteBloc;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    mockNoteRepository = MockNoteRepository();
    noteBloc = NoteBloc(noteRepository: mockNoteRepository);
  });

  tearDown(() {
    noteBloc.close();
  });

  group('NoteBloc', () {
    final mockNote = Note(
      id: '1',
      content: 'Test Note',
      username: 'User1',
    );

    test('initial state is NoteLoading', () {
      expect(noteBloc.state, NoteLoading());
    });

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoading, NoteLoaded] when LoadNotes is added and notes are loaded successfully',
      build: () {
        when(mockNoteRepository.getNotes()).thenAnswer((_) => Stream.value([mockNote]));
        return noteBloc;
      },
      act: (bloc) => bloc.add(LoadNotes()),
      expect: () => [
        NoteLoading(),
        NoteLoaded(notes: [mockNote]),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoaded] when AddNote is added and note is successfully added',
      build: () {
        when(mockNoteRepository.addNote(mockNote)).thenAnswer((_) async {});
        return noteBloc;
      },
      act: (bloc) => bloc.add(AddNote(note: mockNote)),
      expect: () => [],
      verify: (_) {
        verify(mockNoteRepository.addNote(mockNote)).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoaded] when UpdateNote is added and note is successfully updated',
      build: () {
        when(mockNoteRepository.updateNote(mockNote)).thenAnswer((_) async {});
        return noteBloc;
      },
      act: (bloc) => bloc.add(UpdateNote(note: mockNote)),
      expect: () => [],
      verify: (_) {
        verify(mockNoteRepository.updateNote(mockNote)).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [NoteLoaded] when DeleteNote is added and note is successfully deleted',
      build: () {
        when(mockNoteRepository.deleteNote(mockNote.id)).thenAnswer((_) async {});
        return noteBloc;
      },
      act: (bloc) => bloc.add(DeleteNote(noteId: mockNote.id)),
      expect: () => [],
      verify: (_) {
        verify(mockNoteRepository.deleteNote(mockNote.id)).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'emits [ActiveUsersLoaded] when LoadActiveUsers is added and active users are loaded successfully',
      build: () {
        when(mockNoteRepository.getActiveUsers(mockNote.id)).thenAnswer((_) => Stream.value([UserModel(username: 'User1', role: 'viewing', color: '0xFFB71C1C')]));
        return noteBloc;
      },
      act: (bloc) => bloc.add(LoadActiveUsers(noteId: mockNote.id)),
      expect: () => [
        ActiveUsersLoaded(activeUsers: [UserModel(username: 'User1', role: 'viewing', color: '0xFFB71C1C')]),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'adds user to active users when AddUserToActiveUsers is added',
      build: () {
        when(mockNoteRepository.addUserToActiveUsers(mockNote.id, UserModel(username: 'User1', role: 'viewing', color: '0xFFB71C1C'))).thenAnswer((_) async {});
        return noteBloc;
      },
      act: (bloc) => bloc.add(AddUserToActiveUsers(noteId: mockNote.id, user: UserModel(username: 'User1', role: 'viewing', color: '0xFFB71C1C'))),
      expect: () => [],
      verify: (_) {
        verify(mockNoteRepository.addUserToActiveUsers(mockNote.id, UserModel(username: 'User1', role: 'viewing', color: '0xFFB71C1C'))).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'updates user role when UpdateUserRole is added',
      build: () {
        when(mockNoteRepository.updateUserRole(mockNote.id, UserModel(username: 'User1', role: 'editing', color: '0xFFB71C1C'))).thenAnswer((_) async {});
        return noteBloc;
      },
      act: (bloc) => bloc.add(UpdateUserRole(noteId: mockNote.id, user: UserModel(username: 'User1', role: 'editing', color: '0xFFB71C1C'))),
      expect: () => [],
      verify: (_) {
        verify(mockNoteRepository.updateUserRole(mockNote.id, UserModel(username: 'User1', role: 'editing', color: '0xFFB71C1C'))).called(1);
      },
    );

    blocTest<NoteBloc, NoteState>(
      'removes user from active users when RemoveUserFromActiveUsers is added',
      build: () {
        when(mockNoteRepository.removeUserFromActiveUsers(mockNote.id, 'User1')).thenAnswer((_) async {});
        return noteBloc;
      },
      act: (bloc) => bloc.add(RemoveUserFromActiveUsers(noteId: mockNote.id, username: 'User1')),
      expect: () => [],
      verify: (_) {
        verify(mockNoteRepository.removeUserFromActiveUsers(mockNote.id, 'User1')).called(1);
      },
    );
  });
}

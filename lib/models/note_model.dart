class Note {
  String id;
  String content;
  String username;

  Note({
    required this.id,
    required this.content,
    required this.username,
  });

  factory Note.fromMap(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      content: data['content'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'username': username,
    };
  }
}

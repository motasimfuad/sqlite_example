class NoteModel {
  int? id;
  String title;
  String description;
  NoteModel({
    this.id,
    required this.title,
    required this.description,
  });

  NoteModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'title': title,
  //     'description': description,
  //   };
  // }

  // factory NoteModel.fromMap(Map<String, dynamic> map) {
  //   return NoteModel(
  //     id: map['id']?.toInt(),
  //     title: map['title'] ?? '',
  //     description: map['description'] ?? '',
  //   );
  // }

}

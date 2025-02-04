class Note {
  late int id;
  late String title;
  late String content;
  late String date;
  late int? authorID;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.authorID,
  });
}

import 'package:note/models/note.dart';
import 'package:note/models/user.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDB() async {
  final databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (Database instance, int version) async {
      await instance.execute(
          'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT NOT NULL UNIQUE,email TEXT NOT NULL UNIQUE,password TEXT NOT NULL);');
      await instance.execute(
          'CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL,content TEXT NOT NULL,date TEXT NOT NULL,author_id INTEGER,FOREIGN KEY (author_id) REFERENCES user(id));');
    },
  );
}

Future<bool> createUser(User user) async {
  try {
    Database db = await getDB();
    int result = await db.insert('user', user.toMap());
    return result > 0;
  } catch (e) {
    return false;
  }
}

Future<int> loginUser(User user) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  Database db = await getDB();

  try {
    List<Map> result = await db.query('user',
        where: 'email = ? AND password = ?',
        whereArgs: [user.email, user.password]);
    if (result.isEmpty) {
      return 0;
    }
    sp.setInt('id', result[0]['id']);
    return result[0]['id'];
  } catch (e) {
    return 0;
  }
}

Future<User> getUser(int id) async {
  Database db = await getDB();
  List<Map> result = await db.query('user', where: 'id = ?', whereArgs: [id]);
  return User.fromMap(result[0]);
}

Future<Note> addNote({
  required String title,
  required String detail,
  required int authorId,
}) async {
  Database db = await getDB();
  int result = await db.insert('note', {
    'title': title,
    'content': detail,
    'date': DateTime.now().toString(),
    'author_id': authorId
  });
  return Note(
    id: result,
    title: title,
    content: detail,
    date: DateTime.now().toString(),
    authorID: authorId,
  );
}

Future<List<Note>> getNotes(int id) async {
  Database db = await getDB();
  List<Map> result = await db.query(
    'note',
    where: 'author_id = ?',
    whereArgs: [id],
    orderBy: 'date',
  );
  List<Note> notes = result
      .map((e) => Note(
            content: e['content'],
            date: e['date'],
            id: e['id'],
            title: e['title'],
          ))
      .toList();

  notes.sort((a, b) => b.date.compareTo(a.date));

  return notes;
}

Future<bool> updateNote(Note note) async {
  Database db = await getDB();
  int result = await db.update(
    'note',
    {
      'title': note.title,
      'content': note.content,
      'date': DateTime.now().toString(),
    },
    where: 'id = ?',
    whereArgs: [note.id],
  );
  return result > 0;
}

Future<bool> deleteNote(Note note) async {
  Database db = await getDB();
  int result = await db.delete(
    'note',
    where: 'id = ?',
    whereArgs: [note.id],
  );
  return result > 0;
}

import 'package:flutter/material.dart';
import 'package:note/models/note.dart';
import 'package:note/models/user.dart';
import 'package:note/pages/add_note.dart';
import 'package:note/pages/edit_note.dart';
import 'package:note/pages/login_page.dart';
import 'package:note/pages/profile.dart';
import 'package:note/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();

    getUser(widget.userId).then((u) => setState(() => user = u));
    getNotes(widget.userId).then((notes) => setState(() => this.notes = notes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade400,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(
                notes: notes,
                userID: user!.id!,
              ),
            ),
          ).then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal, Colors.greenAccent],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              GestureDetector(
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.teal, Colors.greenAccent],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user?.username ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        username: user!.username,
                        email: user!.email,
                        totalNotes: notes.length,
                      ),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: Text(
                  'Home Page',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Navigate to the homepage
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.note_add,
                  color: Colors.white,
                ),
                title: Text(
                  'Add Note',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNotePage(
                        notes: notes,
                        userID: user!.id!,
                      ),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        username: user!.username,
                        email: user!.email,
                        totalNotes: notes.length,
                      ),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
              ),
              Divider(
                color: Colors.white54,
                thickness: 0.5,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            tileColor:
                Colors.teal.withOpacity(0.1), // Background color of the tile
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
              side: BorderSide(
                  color: Colors.teal.withOpacity(0.2), width: 1.0), // Border
            ),
            leading: Icon(
              Icons.note, // Icon for the note
              color: Colors.teal, // Icon color
              size: 30,
            ),
            title: Text(
              notes[index].title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800, // Title color
              ),
            ),
            subtitle: Text(
              notes[index].content.length < 100
                  ? notes[index].content
                  : "${notes[index].content.substring(0, 150)}...",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700, // Subtitle color
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios, // Trailing icon
              color: Colors.teal, // Icon color
              size: 20,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNotePage(
                    note: notes[index],
                    notes: notes,
                  ),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          ),
        ),
      ),
    );
  }
}

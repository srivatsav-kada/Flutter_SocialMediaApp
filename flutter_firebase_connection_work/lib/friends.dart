import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'new_post.dart';
//import 'display_posts.dart';
import 'package:flutter_firebase_connection_work/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _loggedInUser;
  late List<DocumentSnapshot> _users = [];
  late List<String> _friendIds = [];

  @override
  void initState() {
    super.initState();
    _loggedInUser = FirebaseAuth.instance.currentUser!;
    _fetchFriends();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _users = usersSnapshot.docs
          .where((doc) => doc.id != _loggedInUser.uid)
          .toList();
    });
  }

  Future<void> _fetchFriends() async {
    QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_loggedInUser.uid)
        .collection('friends')
        .get();
    setState(() {
      _friendIds = friendsSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> _addFriend(String friendId) async {
    // Implement logic to add friend
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_loggedInUser.uid)
        .collection('friends')
        .doc(friendId)
        .set({'friendId': friendId});
    _fetchFriends(); // Update friends list after adding
  }

  Future<void> _removeFriend(String friendId) async {
    // Implement logic to remove friend
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_loggedInUser.uid)
        .collection('friends')
        .doc(friendId)
        .delete();
    _fetchFriends(); // Update friends list after removing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Media App',
          style: GoogleFonts.pacifico(),
        ),
        //backgroundColor: Color.fromARGB(255, 193, 215, 205),
      ),
      body: _users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    final isFriend = _friendIds.contains(user.id);
                    return ListTile(
                      title: Text(user['name']),
                      trailing: isFriend
                          ? ElevatedButton(
                              onPressed: () {
                                _removeFriend(user.id);
                              },
                              child: Text('Remove Friend'),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                _addFriend(user.id);
                              },
                              child: Text('Add Friend'),
                            ),
                    );
                  },
                ),
              ),
              /*
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => NewPostPage()),
                    );
                  },
                  child: Text('New Post'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayPhotosPage()),
                    );
                  },
                  child: Text('Display Posts'),
                ),
                  ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayPhotosPage()),
                    );
                  },
                  child: Text('Friends'),
                ),
                */
            ]),
      bottomNavigationBar: Navbars(),
    );
  }
}

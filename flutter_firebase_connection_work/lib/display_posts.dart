/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_navbar.dart';

class DisplayPhotosPage extends StatefulWidget {
  @override
  _DisplayPhotosPageState createState() => _DisplayPhotosPageState();
}

class _DisplayPhotosPageState extends State<DisplayPhotosPage> {
  late String _loggedInUserId;
  late List<String> _friendIds = [];

  @override
  void initState() {
    super.initState();
    _loggedInUserId = FirebaseAuth.instance.currentUser!.uid;
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_loggedInUserId)
          .collection('friends')
          .get();
      setState(() {
        _friendIds = friendsSnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error fetching friends: $e');
      // Handle error
    }
  }

  Stream<QuerySnapshot> _getPostStream() {
    if (_friendIds.isEmpty) {
      // Return a stream that doesn't emit any documents
      return FirebaseFirestore.instance.collection('posts').where('userId', isEqualTo: '').snapshots();
    } else {
      // Return a stream with 'in' filter based on friendIds
      return FirebaseFirestore.instance.collection('posts').where('userId', whereIn: _friendIds).snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Media App',
          style: GoogleFonts.pacifico(),
        ),
      ),
      body: StreamBuilder(
        stream: _getPostStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('users').doc(post['userId']).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${userSnapshot.error}'),
                    );
                  }
                  final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                  final userName = userData?['name'] ?? 'Unknown User';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8 * 0.8,
                          child: Image.network(
                            post['imageUrl'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          post['description'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Divider(),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Navbars(),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bottom_navbar.dart';

class DisplayPhotosPage extends StatefulWidget {
  @override
  _DisplayPhotosPageState createState() => _DisplayPhotosPageState();
}

class _DisplayPhotosPageState extends State<DisplayPhotosPage> {
  late String _loggedInUserId;
  late List<String> _friendIds = [];

  @override
  void initState() {
    super.initState();
    _loggedInUserId = FirebaseAuth.instance.currentUser!.uid;
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_loggedInUserId)
          .collection('friends')
          .get();
      setState(() {
        _friendIds = friendsSnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error fetching friends: $e');
      // Handle error
    }
  }

  Stream<QuerySnapshot> _getPostStream() {
    if (_friendIds.isEmpty) {
      // Return a stream that doesn't emit any documents
      return FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: '')
          .snapshots();
    } else {
      // Return a stream with 'in' filter based on friendIds
      return FirebaseFirestore.instance
          .collection('posts')
          .where('userId', whereIn: _friendIds)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Media App',
          style: GoogleFonts.pacifico(),
        ),
      ),
      body: StreamBuilder(
        stream: _getPostStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final  posts = snapshot.data!.docs;

          if (posts.isEmpty) {
            return Center(
              child: Text(
                'No posts to display',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(post['userId'])
                    .get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${userSnapshot.error}'),
                    );
                  }
                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;
                  final userName = userData?['name'] ?? 'Unknown User';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8 * 0.8,
                          child: Image.network(
                            post['imageUrl'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          post['description'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Divider(),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Navbars(),
    );
  }
}

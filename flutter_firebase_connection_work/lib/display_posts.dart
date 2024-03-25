import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DisplayPhotosPage extends StatefulWidget {
  @override
  _DisplayPhotosPageState createState() => _DisplayPhotosPageState();
}

class _DisplayPhotosPageState extends State<DisplayPhotosPage> {
  late String _loggedInUserId;

  @override
  void initState() {
    super.initState();
    _loggedInUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('userId', isNotEqualTo: _loggedInUserId) // Exclude own posts
            .snapshots(),
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
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(post['userId'])
                    .get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                      // You can customize the loading state as needed
                    );
                  }
                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${userSnapshot.error}'),
                      // You can customize the error state as needed
                    );
                  }
                  //final userData = userSnapshot.data!.data();
                  //final userName = userData?['name'] ?? 'Unknown User';
                  final userData = userSnapshot.data!.data() as Map<String,
                      dynamic>?; // Cast userData to Map<String, dynamic>?
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
                          width: MediaQuery.of(context).size.width *
                              0.8, // Set width to 80% of screen width
                          height: MediaQuery.of(context).size.width *
                              0.8 *
                              0.8, // Set height to 80% of the container width to maintain the aspect ratio
                          child: Image.network(
                            post['imageUrl'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
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
                      SizedBox(
                        height: 25.0,
                      ),
                      Divider(), // Optional: Divider between posts
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

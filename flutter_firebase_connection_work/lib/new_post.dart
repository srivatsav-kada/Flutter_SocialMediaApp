import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'display_posts.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  late TextEditingController _descriptionController;
  File? _imageFile;
  final _picker = ImagePicker();
  late String _loggedInUserId;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _loggedInUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> _uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitPost() async {
    if (_imageFile == null) {
      // Show error message if no image is selected
      return;
    }

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child('$_loggedInUserId/${DateTime.now()}.jpg');

    await storageRef.putFile(_imageFile!);

    final imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance.collection('posts').add({
      'imageUrl': imageUrl,
      'description': _descriptionController.text,
      'userId': _loggedInUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully Posted'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
    // Navigate back to the previous page after submission

    //Navigator.pop(context);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DisplayPhotosPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Media App',
          style: GoogleFonts.pacifico(),
        ),
        actions: [
          IconButton(
            onPressed: _submitPost,
            icon: Icon(Icons.send),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 200,
                fit: BoxFit.cover,
              ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}

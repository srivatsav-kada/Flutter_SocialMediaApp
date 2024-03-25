import 'package:flutter/material.dart';

void main() {
  runApp(Signups());
}

class Signups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Myapps",
      home: SignupsPage(),
    );
  }
}

class SignupsPage extends StatefulWidget {
  _signupsstate createState() => _signupsstate();
}

class _signupsstate extends State<SignupsPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Titles"),
      ),
      body: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: [TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                )],
              ))),
    );
  }
}

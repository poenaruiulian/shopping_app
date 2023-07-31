import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: email()));
  }
}

class email extends StatefulWidget {
  const email({super.key});

  @override
  State<email> createState() => _emailState();
}

class _emailState extends State<email> {
  String _email = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMail();
  }

  void _getMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString("email") ?? "";
    });
  }

  void _setEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = value;
    });
    prefs.setString("email", _email);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(children: [
          TextFormField(
            controller: emailEditingController,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: _email != ""
                  ? "Your email: $_email"
                  : "Enter you email address",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Can't add an empty email adress";
              }
              if (!value.contains('@')) {
                return 'Email is invalid, must contain @';
              }
              if (!value.contains('.')) {
                return 'Email is invalid, must contain .';
              }
              return null;
            },
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton.extended(
                backgroundColor: const Color.fromARGB(255, 93, 172, 238),
                label: const Text("Edit"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _setEmail(emailEditingController.text);
                    emailEditingController.clear();
                  }
                },
              ))
        ]));
  }
}

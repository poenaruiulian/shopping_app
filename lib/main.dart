import 'package:flutter/material.dart';
import 'package:test_app/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Layout demo',
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
                appBar: AppBar(
                  title: const Text("Shopping app"),
                  bottom: const TabBar(tabs: [
                    Tab(icon: Icon(Icons.shopping_cart)),
                    Tab(icon: Icon(Icons.receipt_long)),
                    Tab(icon: Icon(Icons.checklist)),
                    Tab(icon: Icon(Icons.person)),
                  ]),
                ),
                body: const TabBarView(
                  children: <Widget>[
                    HomePage(),
                    RecipesPage(),
                    ListPage(),
                    UserPage(),
                  ],
                ))));
  }
}

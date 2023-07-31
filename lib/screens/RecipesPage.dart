import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:test_app/components/components.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: receipts()));
  }
}

class receipts extends StatefulWidget {
  const receipts({super.key});

  @override
  State<receipts> createState() => _receiptsState();
}

class _receiptsState extends State<receipts> {
  List _items = [];

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    setState(() {
      _items.addAll(data["receipts"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (var item in _items)
          Column(
            children: [
              receiptCard(
                  title: _items[_items.indexOf(item)]["title"] ?? "",
                  imageLink: _items[_items.indexOf(item)]["imageLink"] ?? "",
                  ingredients: _items[_items.indexOf(item)]["ingredients"],
                  ingredientsPrices: _items[_items.indexOf(item)]
                      ["ingredientsPrices"]),
              const Text(" ")
            ],
          )
      ],
    );
  }
}

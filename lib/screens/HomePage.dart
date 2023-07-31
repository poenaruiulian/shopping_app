import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:test_app/components/components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: cards()));
  }
}

class cards extends StatefulWidget {
  const cards({super.key});

  @override
  State<cards> createState() => _cards();
}

class _cards extends State<cards> {
  List _items = [];
  List _initialItems = [];
  List _productTypes = [];

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    setState(() {
      _items.addAll(data["products"]);
      _initialItems.addAll(data["products"]);
      _productTypes.addAll(data["productTypes"]);
    });
  }

  void _searchItem(String item) {
    setState(() {
      _items.clear();
      _items.addAll(_initialItems);

      _items.retainWhere((element) {
        return _items[_items.indexOf(element)]["title"] == item;
      });
    });
  }

  void _filterItems(String tag) {
    setState(() {
      _items.clear();
      _items.addAll(_initialItems);
      
      _items.retainWhere((element) {
        return _items[_items.indexOf(element)]["type"] == tag;
      });
    });
  }

  Future<void> _refreshList() async {
    setState(() {
      _items.clear();
      _items.addAll(_initialItems);
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController searchedItem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshList,
      child: ListView(
        children: <Widget>[
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Form(
                    key: _formKey,
                    child: Row(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextFormField(
                          controller: searchedItem,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Search for your item",
                          ),
                          style: const TextStyle(fontSize: 14),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Can't search for emptyness.";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: FloatingActionButton.extended(
                            backgroundColor:
                                const Color.fromARGB(255, 93, 172, 238),
                            label: const Text("Search",
                                style: TextStyle(fontSize: 14)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _searchItem(searchedItem.text);
                                searchedItem.clear();
                              }
                            },
                          )),
                    ]))
              ]),
          const Text(" "),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var type in _productTypes)
                tag(
                  title: type,
                  onTap: () {
                    _filterItems(type);
                  },
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Column(children: [
              for (var item in _items)
                Column(
                  children: [
                    shopingCard(
                        title: _items[_items.indexOf(item)]["title"] ?? "",
                        imageLink:
                            _items[_items.indexOf(item)]["imageLink"] ?? "",
                        productPrice: _items[_items.indexOf(item)]
                            ["productPrice"]),
                    const Text(" ")
                  ],
                )
            ]),
          )
        ],
      ),
    );
  }
}

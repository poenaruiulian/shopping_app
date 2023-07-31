import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class shopingCard extends StatefulWidget {
  const shopingCard({
    Key? key,
    required this.title,
    required this.imageLink,
    required this.productPrice,
  }) : super(key: key);

  final String title;
  final String imageLink;
  final double productPrice;

  @override
  State<shopingCard> createState() => _shoppingCardState();
}

class _shoppingCardState extends State<shopingCard> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt(widget.title) ?? 0;
      prefs.setDouble("${widget.title}price", widget.productPrice);
    });
  }

  void _increment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt(widget.title) ?? 0) + 1;
      if (_counter == 1) {
        List<String> aux = prefs.getStringList("products") ?? [];
        aux.add(widget.title);
        prefs.setStringList("products", aux);
      }
      prefs.setInt(widget.title, _counter);
    });
  }

  void _decrement() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt(widget.title) ?? 0) - 1 >= 0
          ? (prefs.getInt(widget.title) ?? 0) - 1
          : 0;
      if (_counter == 0) {
        List<String> aux = prefs.getStringList("products") ?? [];
        aux.remove(widget.title);
        prefs.setStringList("products", aux);
      }
      prefs.setInt(widget.title, _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 215, 215, 215),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(widget.title,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold))),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('${widget.productPrice} \$',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)))
                ]),
            const Text(" "),
            Image(
                image: NetworkImage(widget.imageLink), width: 200, height: 200),
            const Text(" "),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                    backgroundColor: Color.fromARGB(255, 121, 147, 241),
                    onPressed: () => _increment(),
                    label: const Text("+",
                        style: TextStyle(fontSize: 30, color: Colors.black))),
                Text('$_counter',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                FloatingActionButton.extended(
                    backgroundColor: Color.fromARGB(255, 121, 147, 241),
                    onPressed: () => _decrement(),
                    label: const Text("-",
                        style: TextStyle(fontSize: 36, color: Colors.black)))
              ],
            ),
            const Text(" ")
          ],
        ));
  }
}

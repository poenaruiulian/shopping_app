import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class receiptCard extends StatefulWidget {
  const receiptCard(
      {Key? key,
      required this.title,
      required this.imageLink,
      required this.ingredients,
      required this.ingredientsPrices})
      : super(key: key);

  final String title;
  final String imageLink;
  final List ingredients;
  final List ingredientsPrices;

  @override
  State<receiptCard> createState() => _receiptCardState();
}

class _receiptCardState extends State<receiptCard> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt("${widget.title}reciept") ?? 0);
      for (var price in widget.ingredientsPrices) {
        prefs.setDouble(
            "${widget.ingredients[widget.ingredientsPrices.indexOf(price)]}price",
            price);
      }
    });
  }

  void _increment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt("${widget.title}reciept") ?? 0) + 1;

      if (_counter == 1) {
        List<String> aux = prefs.getStringList("products") ?? [];
        for (var ingredient in widget.ingredients) {
          aux.retainWhere((element) {
            return element != ingredient;
          });
          aux.add(ingredient);
        }
        prefs.setStringList("products", aux);

        List<String> aux2 = prefs.getStringList("reciepts") ?? [];
        aux2.add(widget.title);
        prefs.setStringList('reciepts', aux2);
      }

      for (var ingredient in widget.ingredients) {
        int newIngredientQuantity = (prefs.getInt(ingredient) ?? 0) + 1;
        prefs.setInt(ingredient, newIngredientQuantity);
      }

      prefs.setInt("${widget.title}reciept", _counter);
    });
  }

  void _decrement() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt("${widget.title}reciept") ?? 0) - 1 >= 0
          ? (prefs.getInt("${widget.title}reciept") ?? 0) - 1
          : 0;
      if (_counter == 0) {
        List<String> aux = prefs.getStringList("products") ?? [];
        for (var ingredient in widget.ingredients) {
          int counterOfProduct = (prefs.getInt(ingredient) ?? 0);
          if (counterOfProduct == 1) {
            aux.remove(ingredient);
          }
          prefs.setInt(ingredient, counterOfProduct);
        }
        prefs.setStringList("products", aux);

        List<String> aux2 = prefs.getStringList("reciepts") ?? [];
        aux2.remove(widget.title);
        prefs.setStringList('reciepts', aux2);
      }

      for (var ingredient in widget.ingredients) {
        int newIngredientQuantity = (prefs.getInt(ingredient) ?? 0) - 1;
        prefs.setInt(ingredient, newIngredientQuantity);
      }

      prefs.setInt("${widget.title}reciept", _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 350,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 215, 215, 215),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(widget.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              const Text(" "),
              Image(
                  image: NetworkImage(widget.imageLink),
                  width: 200,
                  height: 200),
              const Text(" "),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for (var ingredient in widget.ingredients)
                    Text(ingredient, style: TextStyle(fontSize: 16))
                ],
              ),
              const Text(" "),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                      backgroundColor: Color.fromARGB(255, 121, 147, 241),
                      onPressed: _increment,
                      label: const Text("+",
                          style: TextStyle(fontSize: 30, color: Colors.black))),
                  Text('$_counter',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  FloatingActionButton.extended(
                      backgroundColor: Color.fromARGB(255, 121, 147, 241),
                      onPressed: _decrement,
                      label: const Text("-",
                          style: TextStyle(fontSize: 36, color: Colors.black)))
                ],
              ),
              const Text(" ")
            ]));
  }
}

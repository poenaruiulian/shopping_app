import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: products()));
  }
}

class products extends StatefulWidget {
  const products({super.key});

  @override
  State<products> createState() => _products();
}

class _products extends State<products> {
  List<String> _prods = [];
  List<int> _quantity = [];
  List<double> _prices = [];
  List<String> _receipts = [];
  String _email = "";
  double _totalPrice = 0;

  String _emailBody = "";

  @override
  void initState() {
    super.initState();
    _loadProds();
  }

  void _loadProds() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prods = (prefs.getStringList("products") ?? []);
      _receipts = (prefs.getStringList("reciepts") ?? []);
      _email = prefs.getString('email') ?? "";
      for (var prod in _prods) {
        _quantity.add(prefs.getInt(prod) ?? 0);
        _prices.add(prefs.getDouble("${prod}price") ?? 1);
        _totalPrice +=
            _quantity[_prods.indexOf(prod)] * _prices[_prods.indexOf(prod)];
        _emailBody +=
            "${prod} - ${_quantity[_prods.indexOf(prod)]} * ${_prices[_prods.indexOf(prod)]} \$ /buc"
            "\n";
      }
    });
  }

  void resetCart() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _quantity = [];
      _prices = [];
      _totalPrice = 0;

      for (var prod in _prods) {
        prefs.setInt(prod, 0);
        prefs.setDouble('${prod}price', 0);
      }

      for (var receipt in _receipts) {
        prefs.setInt("${receipt}reciept", 0);
      }

      _prods = [];
      prefs.setStringList("products", []);
    });
  }

  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reset shopping cart'),
            content: const Text("Are you sure you want do reset your cart?"),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  onPressed: () {
                    resetCart();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Reset"))
            ],
          );
        });
  }

  Future sendEmail({required String body}) async {
    String platformResponse = "";
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    // ignore: unused_local_variable
    final response = await http
        .post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'service_id': "service_q000m12",
              'template_id': "template_2dxp8fd",
              'user_id': "u86Gk9s48TPvCa4o9",
              'template_params': {'body': body, 'email': _email}
            }))
        .then((value) {
      platformResponse = value.body.toString();
      if (platformResponse == "OK") {
        resetCart();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
      children: [
        const Text(""),
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Check:",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        for (var item in _prods)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(item,
                    style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                    "${_quantity[_prods.indexOf(item)]} bucs * ${_prices[_prods.indexOf(item)]} \$ /buc",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Total:",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("${_totalPrice.toStringAsFixed(2)} \$",
                  style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: FloatingActionButton.extended(
                  backgroundColor: _prods.isEmpty
                      ? const Color.fromARGB(255, 205, 204, 204)
                      : Color.fromARGB(255, 240, 111, 101),
                  onPressed: () {
                    if (_prods.isEmpty) {
                      return;
                    }
                    _showDialog();
                  },
                  label: Text("Reset",
                      style: TextStyle(
                          color:
                              _prods.isEmpty ? Colors.black : Colors.white))),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton.extended(
                  backgroundColor: _prods.isEmpty
                      ? Colors.grey
                      : const Color.fromARGB(255, 94, 168, 96),
                  onPressed: () {
                    if (_prods.isEmpty) {
                      return;
                    }
                    sendEmail(
                      body: "Hello, bellow are your order contents"
                          "\n\n"
                          " $_emailBody "
                          "\n"
                          " Total: ${_totalPrice.toStringAsFixed(2)} \$",
                    );
                  },
                  label: Text("Send order",
                      style: TextStyle(
                          color:
                              _prods.isEmpty ? Colors.black : Colors.white))),
            )
          ],
        )
      ],
    ));
  }
}

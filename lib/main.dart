import 'package:flutter/material.dart';

import 'model/Order.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Order> orders = [];
  String searchKeyword = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Order',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchKeyword = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _itemController,
                          decoration: const InputDecoration(
                            labelText: 'Item',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an item';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _itemNameController,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an item name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a quantity';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 220,
                        child: TextFormField(
                          controller: _currencyController,
                          decoration: const InputDecoration(
                            labelText: 'Currency',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a currency';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          Order newOrder = Order(
                            item: _itemController.text,
                            itemName: _itemNameController.text,
                            quantity: int.parse(_quantityController.text),
                            price: double.parse(_priceController.text),
                            currency: _currencyController.text,
                          );
                          orders.add(newOrder);
                          _itemController.clear();
                          _itemNameController.clear();
                          _quantityController.clear();
                          _priceController.clear();
                          _currencyController.clear();
                        });
                      }
                    },
                    child: const Text('Add Item to Cart'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.orange.withOpacity(0.5);
                        }
                        return Colors.redAccent;
                      }),
                      columns: const [
                        DataColumn(
                          label: Text('Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Item Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Quantity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Price', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('Currency', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                      rows: orders.where((order) {
                        return order.item.toLowerCase().contains(searchKeyword) ||
                            order.itemName.toLowerCase().contains(searchKeyword) ||
                            order.quantity.toString().contains(searchKeyword) ||
                            order.price.toString().contains(searchKeyword) ||
                            order.currency.toLowerCase().contains(searchKeyword);
                      }).map((order) {
                        return DataRow(cells: [
                          DataCell(Text(order.item)),
                          DataCell(Text(order.itemName)),
                          DataCell(Text(order.quantity.toString())),
                          DataCell(Text(order.price.toString())),
                          DataCell(Text(order.currency)),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  orders.remove(order);
                                });
                              },
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

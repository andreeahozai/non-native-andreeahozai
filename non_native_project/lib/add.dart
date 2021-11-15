import 'package:flutter/material.dart';

import 'sql_helper.dart';
import 'main.dart';
import 'book.dart';

class Add extends StatelessWidget {
  const Add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Books',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const AddPage());
  }
}

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _publishingHouseController =
      TextEditingController();

  Future<void> _addItem() async {
    await SQLHelper.createItem(Book(
        title: _titleController.text,
        author: _authorController.text,
        category: _categoryController.text,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        publishing_house: _publishingHouseController.text));
  }

  Future<void> _showMyDialogNumber() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Price should be double and stock should be integer!!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Fields can not be empty!!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body: Center(
          child: Form(
              child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(hintText: 'Author'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(hintText: 'Category'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(hintText: 'Price'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(hintText: 'Stock'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _publishingHouseController,
              decoration: const InputDecoration(hintText: 'Publishing house'),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _authorController.text.isEmpty ||
                      _categoryController.text.isEmpty ||
                      _priceController.text.isEmpty ||
                      _stockController.text.isEmpty ||
                      _publishingHouseController.text.isEmpty) {
                    _showMyDialog();
                  } else {
                    try {
                      double.parse(_priceController.text);
                      int.parse(_stockController.text);
                      _addItem();
                      _titleController.text = '';
                      _authorController.text = '';
                      _categoryController.text = '';
                      _priceController.text = '';
                      _stockController.text = '';
                      _publishingHouseController.text = '';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    } on FormatException {
                      _showMyDialogNumber();
                    }
                  }
                  ;
                },
                child: Text('Add book'),
              ),
            )
          ],
        ),
      ))),
    );
  }
}

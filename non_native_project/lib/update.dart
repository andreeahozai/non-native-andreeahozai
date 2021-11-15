import 'package:flutter/material.dart';

import 'sql_helper.dart';
import 'main.dart';
import 'book.dart';

class Update extends StatelessWidget {
  final Book book;
  const Update({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Books',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: UpdatePage(book: book));
  }
}

class UpdatePage extends StatefulWidget {
  final Book book;
  const UpdatePage({Key? key, required this.book}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _publishingHouseController =
      TextEditingController();

  Future<void> _updateItem(int id) async {
    try {
      await SQLHelper.updateItem(
          id,
          Book(
              title: _titleController.text,
              author: _authorController.text,
              category: _categoryController.text,
              price: double.parse(_priceController.text),
              stock: int.parse(_stockController.text),
              publishing_house: _publishingHouseController.text));
    } on FormatException {
      _showMyDialog();
    }
  }

  Future<void> _showMyDialogNumber() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
              child: Text("Ok"),
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
        title: const Text('Update Book'),
      ),
      body: Center(
          child: Form(
              child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController..text = widget.book.title,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _authorController..text = widget.book.author,
              decoration: const InputDecoration(hintText: 'Author'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _categoryController..text = widget.book.category,
              decoration: const InputDecoration(hintText: 'Category'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _priceController..text = widget.book.price.toString(),
              decoration: const InputDecoration(hintText: 'Price'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _stockController..text = widget.book.stock.toString(),
              decoration: const InputDecoration(hintText: 'Stock'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _publishingHouseController
                ..text = widget.book.publishing_house,
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
                    _updateItem(widget.book.id);

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
                  }
                  ;
                },
                child: Text('Update book'),
              ),
            )
          ],
        ),
      ))),
    );
  }
}

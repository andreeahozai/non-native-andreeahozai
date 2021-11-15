import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'book.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        author TEXT,
        category TEXT,
        price TEXT,
        stock TEXT,
        publishing_house
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'booksdb.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<Book> createItem(Book book) async {
    final db = await SQLHelper.db();

    final data = {
      'title': book.title,
      'author': book.author,
      'category': book.category,
      'price': book.price,
      'stock': book.stock,
      'publishing_house': book.publishing_house
    };
    final id = await db.insert('books', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return book;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('books', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('books', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<Book> updateItem(int id, Book book) async {
    final db = await SQLHelper.db();

    final data = {
      'title': book.title,
      'author': book.author,
      'category': book.category,
      'price': book.price,
      'stock': book.stock,
      'publishing_house': book.publishing_house,
    };

    final result =
        await db.update('books', data, where: "id = ?", whereArgs: [id]);
    return book;
  }

  static Future<int> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("books", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting a book: $err");
    }
    return id;
  }
}

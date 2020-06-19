import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dailynotes/models/product.dart';

class DbHelper {
  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "dgn2.db");
    var eTradeDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTradeDb;
  }

  void createDb(Database db, int version) async {
    await db.execute("Create table products(id integer primary key, name text, description text, unitPrice integer, date date, done integer, active integer)");
  }

  Future<List<Product>> getProducts({bool isOnlyToday}) async {
    Database db = await this.db;

    List<Map<String, dynamic>> result;

    if (isOnlyToday) {
      var dt = DateTime.now();
      var date = "${dt.year}-${dt.month}-${dt.day}";
      result = await db.query("products", orderBy: "date DESC, id DESC", where: "date=?", whereArgs: [date]);
    } else
      result = await db.query("products", orderBy: "date DESC, id DESC");

    return List.generate(result.length, (i) {
      return Product.fromObject(result[i]);
    });
  }

  Future<int> add(Product product) async {
    Database db = await this.db;
    var result = await db.insert("products", product.toMap());
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.db;
    var result = await db.rawDelete("delete from products where id=$id");
    return result;
  }

  Future<int> update(Product product) async {
    Database db = await this.db;
    var result = await db.update("products", product.toMap(), where: "id=?", whereArgs: [product.id]);
    return result;
  }
}

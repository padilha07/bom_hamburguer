import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../app/providers/cart_provider.dart';
import '../app/models/product.dart';

class DatabaseHelper {
  static const _databaseName = "cart.db";
  static const _databaseVersion = 1;

  static const table = 'cart_items';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnPrice = 'price';
  static const columnImage = 'image';
  static const columnCategory = 'category';
  static const columnQuantity = 'quantity';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPrice REAL NOT NULL,
            $columnImage TEXT NOT NULL,
            $columnCategory TEXT NOT NULL,
            $columnQuantity INTEGER NOT NULL
          )
          ''');
  }

  Future<int> upsert(CartItem item) async {
    Database db = await instance.database;
    return await db.insert(
      table,
      _cartItemToMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartItem>> getAllItems() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return _mapToCartItem(maps[i]);
    });
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> clear() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Map<String, dynamic> _cartItemToMap(CartItem item) {
    return {
      columnId: item.product.id,
      columnName: item.product.name,
      columnPrice: item.product.price,
      columnImage: item.product.image,
      columnCategory: item.product.category,
      columnQuantity: item.quantity,
    };
  }

  CartItem _mapToCartItem(Map<String, dynamic> map) {
    return CartItem(
      product: Product(
        id: map[columnId],
        name: map[columnName],
        price: map[columnPrice],
        image: map[columnImage],
        category: map[columnCategory],
      ),
      quantity: map[columnQuantity],
    );
  }
}
import 'dart:async';
import 'dart:io';

import 'package:nedfi_seller_common_code/model/ProductResponse.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/MarketProductResponse.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();

  static final SQLiteDbProvider db = SQLiteDbProvider._();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    // Directory documentsDirectory = await
    getApplicationDocumentsDirectory();
    // String path = join('data', 'flutter1.db');//join(documentsDirectory.path, "flutter1.db");
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "data_flutter1.db");
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('data', 'flutter1.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }
    return await openDatabase(path, version: 2, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Product ("
          "id INTEGER PRIMARY KEY,"
          "partner_id TEXT,"
          "product_name TEXT,"
          "price TEXT,"
          "logo TEXT,"
          "category_id TEXT,"
          "type TEXT,"
          "product_type TEXT,"
          "purchase_limit TEXT,"
          "in_stock TEXT,"
          "qty TEXT"
          ")");
    });
  }

  Future<List<ProductsList>> getAllProducts() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query("Product", orderBy: "id ASC");
    List<ProductsList> products = [];
    for (var result in results) {
      ProductsList product = ProductsList.fromJson(result);
      products.add(product);
    }
    return products;
  }

  Future<Object> getProductById(int id) async {
    final db = await database;
    var result = await db!.query("Product", where: "id = ", whereArgs: [id]);
    return result.isNotEmpty ? MarketProductData.fromJson(result.first) : Null;
  }

  insert(ProductsList product) async {
    final db = await database;
    var maxIdResult = await db!.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Product");
    // var id = maxIdResult.first["last_inserted_id"];
    var result = await db.rawInsert(
        "INSERT Into Product (id, partner_id, product_name, price, logo,category_id,type,product_type,qty,purchase_limit,in_stock)"
            " VALUES (?, ?, ?, ?, ?,?,?,?,?,?,?)",
        [product.id, product.partnerId, product.productName, product.price, product.logo, product.categoryId, product.type, product.productType, product.qty, product.purchaseLimit,product.inStock]);

    return result;
  }

  update(ProductsList product) async {
    final db = await database;
    var result = await db!.update("Product", product.toJson(), where: "id = ?", whereArgs: [product.id]);
    return result;
  }

  delete(String id) async {
    final db = await database;
    db!.delete("Product", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db!.delete("Product");
  }

  Future<int> updatecart(String partner_id, String qty) async {
    var dbClient = await database;
    Map<String, dynamic> row = {"qty": qty};

    int updateCount = await dbClient!.update("Product", row, where: 'id = ?', whereArgs: [partner_id]);
    return updateCount;
  }
}

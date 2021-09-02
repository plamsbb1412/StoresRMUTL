import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stoerrmutl/model/cart_model.dart';

class SQLiteHelper {
  final String nameDatabase = 'storeRMUTL.db';
  final String tableDatabase = 'orderTABLE';
  int version = 1;

  final String idColumn = "id";
  final String idStoreColumn = "idStore";
  final String nameStore = "nameStore";
  final String idFood = "idFood";
  final String nameFood = "nameFood";
  final String price = "price";
  final String amount = "amount";
  final String sum = "sum";

  SQLiteHelper() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableDatabase ($idColumn INTEGER PRIMARY KEY, $idStoreColumn TEXT,$nameStore TEXT,$idFood TEXT,$nameFood TEXT,$price TEXT,$amount TEXT,$sum TEXT)'),
        version: version);
  }

  Future<Database> connectedDatabase() async {
    return openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDataToSQLite(CartModel cartModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        tableDatabase,
        cartModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('e insertData ==>> ${e.toString()}');
    }
  }

  Future<List<CartModel>> readAllDataFromSQLite() async {
    Database database = await connectedDatabase();
    List<CartModel> cartModels = List();

    List<Map<String, dynamic>> maps = await database.query(tableDatabase);
    for (var map in maps) {
      CartModel cartModel = CartModel.fromJson(map);
      cartModels.add(cartModel);
    }

    return cartModels;
  }

  Future<Null> deleteSQLiteWhereId(int id) async {
    Database database = await connectedDatabase();
    await database.delete(tableDatabase, where: '$idColumn = $id');
  }

  Future<Null> deleteAll() async {
    Database database = await connectedDatabase();
    await database.delete(tableDatabase);
  }
}

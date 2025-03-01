import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? _database;
List wholeDataList = [];

class Localdb {
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB("Local.db");
    return _database;
  }

  Future _initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE Localdata(id INTEGER PRIMARY KEY,
Name TEXT NOT NULL)
    ''');
  }

  Future addDataLocally({required String name}) async {
    final db = await database;

    await db.insert("Localdata", {"Name": name});
    print("$name adicionada no banco de dados");

    return "Adiconado";
  }

  Future readAllData() async {
    final db = await database;
    final allData = await db!.query("Localdata");
    wholeDataList = allData;
    print(wholeDataList);
    return wholeDataList;
  }

  Future updateData({required id, required name}) async {
    final db = await database;
    int dbUpdateId = await db
        .rawUpdate("UPDATE Localdata SET Name=? WHERE id=?", [name, id]);
    return dbUpdateId;
  }

  Future deleteDb({required id}) async {
    final db = await database;
    await db!.delete("Localdata", where: 'id=?', whereArgs: [id]);
    print("Deletado com sucesso");
    return "Sucesso deletado";
  }
}

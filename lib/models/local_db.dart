import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? _database;
List allDataTipoTelaList = [];
List allDataParcelamentoCard = [];
List allDataUserList = [];

class LocalDbCal {
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB("LocalCal.db");
    return _database;
  }

  Future _initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE TipoTela (id INTEGER PRIMARY KEY,
NomeTela TEXT NOT NULL,
MargemLucro FLOAT NOT NULL)
''');
    await db.execute('''
CREATE TABLE ParcelamentoCard (id INTEGER PRIMARY KEY,
NumParcela INT NOT NULL,
TaxaJuros FLOAT NOT NULL,
Status INT NOT NULL)
''');

    await db.execute('''
  CREATE TABLE Usuario(id INTEGER PRIMATY KEY,
  Nome TEXT NOT NULL,
  MaoDeObra FLOAT NOT NULL)
''');

    // inserindo dados padrao
    db.insert("ParcelamentoCard", {
      "NumParcela": 1,
      "TaxaJuros": 2.9,
      "Status": 1,
    });
    for (var a = 1; a <= 12; a++) {
      db.insert("ParcelamentoCard", {
        "NumParcela": a,
        "TaxaJuros": 4 + a,
        "Status": 0,
      });
      print("Inserido index: $a");
    }

    db.insert("Usuario", {"id": "1", "Nome": "Padrão", "MaoDeObra": 100});

    //FIM inserindo dados padrao
  }

  Future deletarParcCard() async {
    final db = await database;

    await db.execute('''
  DROP TABLE IF EXISTS ParcelamentoCard
''');

    await db.execute('''
CREATE TABLE ParcelamentoCard (id INTEGER PRIMARY KEY,
NumParcela INT NOT NULL,
TaxaJuros FLOAT NOT NULL,
Status INT NOT NULL)
''');

    // inserindo dados padrao
    db.insert("ParcelamentoCard", {
      "NumParcela": 1,
      "TaxaJuros": 2.0,
      "Status": 1,
    });
    for (var a = 1; a <= 12; a++) {
      db.insert("ParcelamentoCard", {
        "NumParcela": a,
        "TaxaJuros": 4 + a,
        "Status": 0,
      });
    }
  }

  Future addTipoTela({required nomeTela, required margemLucro}) async {
    final db = await database;
    await db
        .insert("TipoTela", {"NomeTela": nomeTela, "MargemLucro": margemLucro});
    print("$nomeTela adicionado");
    readAllData();
    return "Adicionado";
  }

  Future readAllData() async {
    final db = await database;
    final allData = await db!.query("TipoTela");
    allDataTipoTelaList = allData;
    print(allDataTipoTelaList);
    return allDataTipoTelaList;
  }

  Future updateData(
      {required int id,
      required String nameTela,
      required double margemLucro}) async {
    final db = await database;
    int dbUpdateID = await db.rawUpdate(
        "UPDATE TipoTela SET NomeTela=?,MargemLucro=? WHERE id=?",
        [nameTela, margemLucro, id]);
    readAllData();
    return dbUpdateID;
  }

  Future deleteDb({required id}) async {
    final db = await database;
    await db!.delete("TipoTela", where: 'id=?', whereArgs: [id]);
    readAllData();
    print("Deletado com sucesso");
    return "Deletado com Sucesso";
  }

  //Parcelamento Cartão

  Future updateStatusParcelamento(
      {required int status, required int id}) async {
    final db = await database;
    await db!.rawUpdate(
        "UPDATE ParcelamentoCard SET Status=? WHERE id=?", [status, id]);
  }

  Future allDataParceCard() async {
    final db = await database;
    var allData = await db.query("ParcelamentoCard");
    allDataParcelamentoCard = allData;
    return allDataParcelamentoCard;
  }

  Future updateTaxaDeJuros({required double taxaJuros, required int id}) async {
    final db = await database;
    await db!.rawUpdate(
        "UPDATE ParcelamentoCard SET TaxaJuros=? WHERE id=?", [taxaJuros, id]);
  }

  //Parcelamento Cartão

  //Dados Usuarios

  Future updateMaoObraUser({required double maoDeObra, required int id}) async {
    final db = await database;
    db.insert("Usuario", {"id": "1", "Nome": "Padrão", "MaoDeObra": 100});

    await db!.rawUpdate(
        "UPDATE Usuario SET MaoDeObra=? WHERE id=?", [maoDeObra, id]);
    print("user Atualizado");
  }

  Future allDataUser() async {
    final db = await database;
    var allData = await db!.query("Usuario");
    allDataUserList = allData;
    return allDataUserList;
  }

  Future deleteDbUser({required int id}) async {
    final db = await database;
    await db!.delete("Usuario", where: 'id=?', whereArgs: [id]);
    print("Deletado com sucesso");
    return "Deletado com Sucesso";
  }

  //Dados Usuarios
}

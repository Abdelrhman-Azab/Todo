import 'package:sqflite/sqflite.dart';

Database? dataBase;

void createDataBase() async {
  dataBase = await openDatabase(
    "tasks.db",
    version: 1,
    onCreate: (db, version) async {
      print("Database created successfuly");
      await db.execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, task TEXT, time TEXT, date TEXT)');
    },
    onOpen: (db) {
      print("Database opened successfuly");
    },
  );
}

void insertToDataBase(
    {required String task, required String time, required String date}) async {
  dataBase!.transaction((txn) async {
    await txn
        .rawDelete(
            'INSERT INTO Tasks(task, time, date) VALUES("$task ", "$time", "$date")')
        .then((value) {
      print("$value inserted successfuly");
    }).catchError((error) {
      print(error.toString());
    });
  });
}

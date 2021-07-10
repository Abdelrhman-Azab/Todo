import 'package:sqflite/sqflite.dart';
import 'package:todo/components/constants.dart';

late Database dataBase;
bool emptyDataBase = false;

void createDataBase() async {
  dataBase = await openDatabase(
    "tasks.db",
    version: 1,
    onCreate: (db, version) async {
      print("Database created successfuly");
      await db.execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, task TEXT, time TEXT, date TEXT)');
    },
    onOpen: (db) async {
      print("Database opened successfuly");
      await getFromDataBase(db);
    },
  );
}

Future insertToDataBase(
    {required String task, required String time, required String date}) async {
  dataBase.transaction((txn) async {
    return await txn
        .rawDelete(
            'INSERT INTO Tasks(task, time, date) VALUES("$task ", "$time", "$date")')
        .then((value) {
      print("$value inserted successfuly");
    }).catchError((error) {
      print(error.toString());
    });
  });
}

Future<List<Map>> getFromDataBase(Database db) async {
  tasks = await db.rawQuery("SELECT * FROM Tasks");
  tasks.length == 0 ? emptyDataBase = true : emptyDataBase = false;

  return tasks;
}

deleteFromDataBase(String time) async {
  await dataBase.rawDelete('DELETE FROM Tasks WHERE time = "$time"');
}

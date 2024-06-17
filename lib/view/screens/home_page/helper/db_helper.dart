import 'package:database_management_system/view/screens/home_page/model/student_model.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

// Mixin => Abstract Class
mixin StudentDB {
  void initDB();

  void insertStudentData({required StudentModel stud});

  void updateStudentData();

  void deleteStudentData();
}

class DBHelper with StudentDB {
  DBHelper._() {
    initDB();
  }

  static final DBHelper dbHelper = DBHelper._();
  late Database db;

  String sql = "";

  String studTable = "Students";
  Logger logger = Logger();

  @override
  Future<void> initDB() async {
    String dbPath = await getDatabasesPath();
    String path = "${dbPath}student.db";

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        sql = '''CREATE TABLE IF NOT EXISTS $studTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          image BLOB
          name TEXT NOT NULL,
          age INTEGER NOT NULL,
          date TEXT NOT NULL
          );''';

        await db.execute(sql).then((value) {
          logger.i("$studTable Table is Created Successfully...");
        }).onError((error, _) {
          logger.e("$studTable is Creation Field....");
        });
      },
    );
  }

  @override
  Future<void> insertStudentData({required StudentModel stud}) async {
    Map<String, dynamic> data = {
      "image": stud.studImage,
      "name": stud.name,
      "age": stud.age,
      "date": stud.date
    };
    await db.insert(studTable, data);
  }

  @override
  void updateStudentData() {
    // TODO: implement updateStudentData
  }

  @override
  void deleteStudentData() {
    // TODO: implement deleteStudentData
  }
}

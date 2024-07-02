import 'package:database_management_system/view/screens/home_page/model/student_model.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

// Mixin => Abstract Class
mixin StudentDB {
  void initDB();

  void insertStudentData({required StudentModel stud});

  void fetchAllStudentData();

  void updateStudentData({required StudentModel stud});

  void deleteStudentData({required int id});
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
          image BLOB NOT NULL,
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
    await db.insert(studTable, stud.toMap).then((value) {
      logger.i("$studTable is Inserted Successfully...");
    });
  }

  @override
  Future<List<StudentModel>> fetchAllStudentData() async {
    List<Map<String, dynamic>> allData = await db.query(studTable);

    return allData
        .map(
          (e) => StudentModel.fromMap(data: e),
        )
        .toList();
  }

  @override
  Future<void> updateStudentData({required StudentModel stud}) async {
    await db.update(
      studTable,
      stud.toMap,
      where: "id = ?",
      whereArgs: [stud.id],
    );
  }

  @override
  Future<void> deleteStudentData({required int id}) async {
    await db.delete(
      studTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:database_management_system/view/screens/home_page/helper/db_helper.dart';
import 'package:database_management_system/view/screens/home_page/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentController extends ChangeNotifier {
  List<StudentModel> studentList = [];
  StudentModel studentModel = StudentModel(
    id: 0,
    name: "",
    image: null,
    studImage: Uint8List(0),
    age: 0,
    dateTime: null,
    date: "",
  );

  StudentController() {
    fetchStudentData();
  }

  void addStudentBirthDate({required DateTime? dateTime}) {
    studentModel.dateTime = dateTime;
    notifyListeners();
  }

  Future<void> addStudentImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      studentModel.image = File(pickedFile.path);
    }
    notifyListeners();
  }

  void assignNullValueForImageOrDate() {
    studentModel.image = null;
    studentModel.dateTime = null;
    notifyListeners();
  }

  Future<void> addStudentData({
    required String name,
    required int age,
  }) async {
    StudentModel stud = StudentModel(
      id: studentModel.id,
      name: name,
      image: null,
      studImage: studentModel.image?.readAsBytesSync() ?? Uint8List(0),
      age: age,
      dateTime: null,
      date:
          "${studentModel.dateTime?.day}/${studentModel.dateTime?.month}/${studentModel.dateTime?.year}",
    );
    await DBHelper.dbHelper.insertStudentData(stud: stud).then(
          (value) => fetchStudentData(),
        );
    notifyListeners();
  }

  Future<void> fetchStudentData() async {
    studentList = await DBHelper.dbHelper.fetchAllStudentData();
    notifyListeners();
  }

  Future<void> updateStudentData(
      {required String name, required int age, required int id}) async {
    log("NAME : $name");
    log("AGE : $age");
    StudentModel stud = StudentModel(
      id: id,
      name: name,
      image: null,
      studImage: studentModel.image?.readAsBytesSync() ?? Uint8List(0),
      age: age,
      dateTime: null,
      date:
          "${studentModel.dateTime?.day}/${studentModel.dateTime?.month}/${studentModel.dateTime?.year}",
    );
    await DBHelper.dbHelper.updateStudentData(stud: stud).then(
          (value) => fetchStudentData(),
        );
    notifyListeners();
  }

  Future<void> deleteStudentData({required int id}) async {
    await DBHelper.dbHelper.deleteStudentData(id: id).then(
          (value) => fetchStudentData(),
        );

    notifyListeners();
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:database_management_system/view/screens/home_page/helper/db_helper.dart';
import 'package:database_management_system/view/screens/home_page/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentController extends ChangeNotifier {
  StudentModel studentModel = StudentModel(
    id: 0,
    name: "",
    image: null,
    studImage: Uint8List(0),
    age: 0,
    dateTime: null,
    date: "",
  );

  void addStudentBirthDate({required DateTime? dateTime}) {
    studentModel.dateTime = dateTime;
    notifyListeners();
  }

  // void addStudentImage({required String? image}) {
  //   studentModel.image = image as File?;
  //   notifyListeners();
  // }

  Future<void> addStudentImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      studentModel.image = File(pickedFile.path);
    }
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
    await DBHelper.dbHelper.insertStudentData(stud: stud);
  }
}

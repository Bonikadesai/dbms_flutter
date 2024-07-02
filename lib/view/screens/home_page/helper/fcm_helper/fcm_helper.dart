import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_management_system/view/screens/home_page/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:toastification/toastification.dart';

mixin StudentFCM {
  void insertFCMData({required StudentModel stud});

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllFCMData();

  void updateFCMData({required int id});

  void deleteFCMData({required int id});
}

class FCMHelper with StudentFCM {
  FCMHelper._();

  static FCMHelper fcmHelper = FCMHelper._();

  Logger logger = Logger();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String studCollection = "students";

  @override
  void insertFCMData({required StudentModel stud}) {
    Map<String, dynamic> data = {
      'id': stud.id,
      'name': stud.name,
      'age': stud.age,
      'date': stud.date,
      'image': String.fromCharCodes(stud.studImage),
    };

    logger.i("DATA : $data");

    firestore
        .collection(studCollection)
        .doc(stud.id.toString())
        .set(data)
        .then(
          (value) => toastification.show(
            title: const Text(
              "Student Data ADDED Successfully",
            ),
            autoCloseDuration: const Duration(seconds: 5),
            type: ToastificationType.success,
            backgroundColor: Colors.green.shade200,
          ),
        )
        .onError(
      (error, stackTrace) {
        logger.e("ERROR : $error");
        return toastification.show(
          title: const Text(
            "Student Data ADDED Field...",
          ),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.error,
          backgroundColor: Colors.redAccent.shade200,
        );
      },
    );
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllFCMData() {
    return firestore.collection(studCollection).snapshots();
  }

  @override
  Future<void> updateFCMData({required int id}) async {
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(
                "https://i.pinimg.com/736x/c3/eb/1e/c3eb1e45a80ce92a94590fc16e73da4f.jpg"))
            .load(
                "https://i.pinimg.com/736x/c3/eb/1e/c3eb1e45a80ce92a94590fc16e73da4f.jpg"))
        .buffer
        .asUint8List();
    Map<String, dynamic> data = {
      'id': id,
      'name': "Flutter",
      'age': 25,
      'image': String.fromCharCodes(bytes),
    };
    firestore.collection(studCollection).doc(id.toString()).update(data);
  }

  @override
  Future<void> deleteFCMData({required int id}) async {
    firestore.collection(studCollection).doc(id.toString()).delete();
  }
}

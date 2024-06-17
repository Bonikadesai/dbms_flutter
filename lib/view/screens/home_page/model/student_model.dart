import 'dart:io';
import 'dart:typed_data';

class StudentModel {
  int id;
  String name;
  File? image;
  Uint8List studImage;
  int age;
  DateTime? dateTime;
  String date;

  StudentModel({
    required this.id,
    required this.name,
    this.image,
    required this.studImage,
    required this.age,
    this.dateTime,
    required this.date,
  });

  factory StudentModel.fromMap({required Map<String, dynamic> data}) {
    return StudentModel(
      id: data['id'],
      name: data['name'],
      studImage: data['image'],
      age: data['age'],
      dateTime: data['dateTime'],
      date: data['date'],
    );
  }

  Map<String, dynamic> get toMap => {
        'image': studImage,
        'name': name,
        'age': age,
        'date': date,
      };
}

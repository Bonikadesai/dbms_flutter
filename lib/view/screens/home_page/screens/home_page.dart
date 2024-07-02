import 'dart:developer';

import 'package:database_management_system/utills/routes/routes.dart';
import 'package:database_management_system/view/screens/home_page/controller/student_controller.dart';
import 'package:database_management_system/view/screens/home_page/helper/fcm_helper/fcm_helper.dart';
import 'package:database_management_system/view/screens/home_page/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GlobalKey<FormState> addInFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provideTrue = Provider.of<StudentController>(context,
        listen: true); // controller attributes use
    var provideFalse = Provider.of<StudentController>(context,
        listen: false); // call only for controllers methods
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(
            fontSize: textScaler.scale(22),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.fcmPage);
            },
            icon: const Icon(Icons.notification_add),
          ),
        ],
      ),
      body: Consumer<StudentController>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.studentList.length,
            itemBuilder: (context, index) {
              StudentModel data = provider.studentList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.6,
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          provider.deleteStudentData(id: data.id).then(
                                (value) => toastification.show(
                                  title: const Text(
                                      "Student Data Deleted Successfully"),
                                  autoCloseDuration: const Duration(seconds: 5),
                                  type: ToastificationType.success,
                                  backgroundColor: Colors.redAccent.shade200,
                                ),
                              );
                        },
                        icon: Icons.delete,
                        backgroundColor: Colors.redAccent.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          nameController.text = data.name;
                          ageController.text = data.age.toString();

                          showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text("STUDENT UPDATE DATA"),
                                  content: Form(
                                    key: addInFormKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Consumer<StudentController>(
                                            builder:
                                                (context, provider, child) {
                                              return Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage: (provider
                                                                .studentModel
                                                                .image !=
                                                            null)
                                                        ? FileImage(provider
                                                                .studentModel
                                                                .image!)
                                                            as ImageProvider
                                                        : MemoryImage(
                                                            data.studImage,
                                                          ),
                                                  ),
                                                  FloatingActionButton.small(
                                                    onPressed: () async {
                                                      await provider
                                                          .addStudentImage();
                                                    },
                                                    child: const Icon(
                                                      Icons.camera_alt_outlined,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            controller: nameController,
                                            validator: (val) => (val!.isEmpty)
                                                ? "Required Name"
                                                : null,
                                            decoration: InputDecoration(
                                              label: const Text("Name"),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.purpleAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            controller: ageController,
                                            validator: (val) => (val!.isEmpty)
                                                ? "Required Age"
                                                : null,
                                            decoration: InputDecoration(
                                              label: const Text("Age"),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.purpleAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  DateTime? dateTime =
                                                      await showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime.now(),
                                                  );
                                                  log("${dateTime?.day ?? 0}");

                                                  if (dateTime != null) {
                                                    provideFalse
                                                        .addStudentBirthDate(
                                                            dateTime: dateTime);
                                                  }
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                    Icons.date_range),
                                              ),
                                              Text(
                                                  "${provideTrue.studentModel.dateTime?.day ?? 'DD'}/${provideTrue.studentModel.dateTime?.month ?? 'MM'}/${provideTrue.studentModel.dateTime?.year ?? 'YYYY'}")
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (addInFormKey.currentState!
                                                  .validate()) {
                                                String name =
                                                    nameController.text;
                                                int age = int.parse(
                                                    ageController.text);

                                                provider
                                                    .updateStudentData(
                                                      name: name,
                                                      age: age,
                                                      id: data.id,
                                                    )
                                                    .then(
                                                      (value) =>
                                                          toastification.show(
                                                        title: const Text(
                                                            "Student Data Updated Successfully"),
                                                        autoCloseDuration:
                                                            const Duration(
                                                                seconds: 5),
                                                        type: ToastificationType
                                                            .success,
                                                        backgroundColor: Colors
                                                            .green.shade200,
                                                      ),
                                                    )
                                                    .onError(
                                                      (error, stackTrace) =>
                                                          toastification.show(
                                                        title: const Text(
                                                            "Student Data Updation Field.."),
                                                        autoCloseDuration:
                                                            const Duration(
                                                                seconds: 5),
                                                        type: ToastificationType
                                                            .error,
                                                        backgroundColor: Colors
                                                            .redAccent.shade200,
                                                      ),
                                                    );

                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.purpleAccent,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(20),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        icon: Icons.edit,
                        backgroundColor: Colors.deepPurpleAccent.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          FCMHelper.fcmHelper.insertFCMData(stud: data);
                        },
                        icon: Icons.info,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: MemoryImage(data.studImage),
                      ),
                      title: Text(data.name),
                      subtitle: Text("Age : ${data.age}"),
                      trailing: Text(data.date),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text("STUDENT DATA"),
                  content: Form(
                    key: addInFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer<StudentController>(
                            builder: (context, provider, child) {
                              return Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: (provider
                                                .studentModel.image !=
                                            null)
                                        ? FileImage(
                                                provider.studentModel.image!)
                                            as ImageProvider
                                        : const AssetImage("assets/pick.png"),
                                  ),
                                  FloatingActionButton.small(
                                    onPressed: () async {
                                      await provider.addStudentImage();
                                    },
                                    child:
                                        const Icon(Icons.camera_alt_outlined),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: nameController,
                            validator: (val) =>
                                (val!.isEmpty) ? "Required Name" : null,
                            decoration: InputDecoration(
                              label: const Text("Name"),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.purpleAccent,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: ageController,
                            validator: (val) =>
                                (val!.isEmpty) ? "Required Age" : null,
                            decoration: InputDecoration(
                              label: const Text("Age"),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.purpleAccent,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );
                                  log("${dateTime?.day ?? 0}");

                                  if (dateTime != null) {
                                    provideFalse.addStudentBirthDate(
                                        dateTime: dateTime);
                                  }
                                  setState(() {});
                                },
                                icon: const Icon(Icons.date_range),
                              ),
                              Text(
                                  "${provideTrue.studentModel.dateTime?.day ?? 'DD'}/${provideTrue.studentModel.dateTime?.month ?? 'MM'}/${provideTrue.studentModel.dateTime?.year ?? 'YYYY'}")
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (addInFormKey.currentState!.validate()) {
                                addInFormKey.currentState!.save();

                                String name = nameController.text;
                                int age = int.parse(ageController.text);

                                await provideFalse
                                    .addStudentData(name: name, age: age)
                                    .then(
                                  (value) {
                                    Navigator.pop(context);
                                    toastification.show(
                                      title: const Text(
                                          "Student Data Inserted Successfully"),
                                      autoCloseDuration:
                                          const Duration(seconds: 5),
                                      type: ToastificationType.success,
                                      backgroundColor: Colors.green,
                                    );

                                    nameController.clear();
                                    ageController.clear();
                                    provideFalse
                                        .assignNullValueForImageOrDate();
                                  },
                                ).onError((error, stackTrace) {
                                  Navigator.pop(context);
                                  log("ERROR : $error");
                                  toastification.show(
                                    title: const Text(
                                        "Student Data Insertion Failed"),
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
                                    backgroundColor: Colors.redAccent,
                                    type: ToastificationType.error,
                                  );
                                });
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.purpleAccent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: textScaler.scale(20),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

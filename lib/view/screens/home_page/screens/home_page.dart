import 'dart:developer';

import 'package:database_management_system/view/screens/home_page/controller/student_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> addInFormKey = GlobalKey<FormState>();
    var provideTrue = Provider.of<StudentController>(context, listen: true);
    var provideFalse = Provider.of<StudentController>(context, listen: false);
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(
            fontSize: textScaler.scale(22),
          ),
        ),
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
                                    );
                                  },
                                ).onError((error, stackTrace) {
                                  Navigator.pop(context);
                                  log("ERROR : $error");
                                  toastification.show(
                                    title: const Text(
                                        "Student Data Insertion Failed"),
                                    autoCloseDuration:
                                        const Duration(seconds: 5),
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

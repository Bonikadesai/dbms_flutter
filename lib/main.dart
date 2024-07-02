import 'package:database_management_system/utills/routes/routes.dart';
import 'package:database_management_system/view/screens/home_page/controller/student_controller.dart';
import 'package:database_management_system/view/screens/home_page/helper/db_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.dbHelper.initDB();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StudentController(),
        ),
      ],
      builder: (context, child) => ToastificationWrapper(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: Routes.myRoutes,
        ),
      ),
    );
  }
}

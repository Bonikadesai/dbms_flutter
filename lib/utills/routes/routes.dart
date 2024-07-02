import 'package:database_management_system/view/screens/fcm_page/screen/fcm_page.dart';
import 'package:flutter/material.dart';

import '../../view/screens/home_page/screens/home_page.dart';

class Routes {
  static const String homePage = '/';
  static const String fcmPage = 'fcm_page';

  static Map<String, WidgetBuilder> myRoutes = {
    homePage: (context) => HomePage(),
    fcmPage: (context) => const FcmPage(),
  };
}

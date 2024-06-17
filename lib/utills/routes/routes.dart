import 'package:flutter/material.dart';

import '../../view/screens/home_page/screens/home_page.dart';

class Routes {
  static const String homePage = '/';

  static Map<String, WidgetBuilder> myRoutes = {
    homePage: (context) => HomePage(),
  };
}

import 'package:get/get.dart';
import 'package:pulz/screens/dashboard.dart';
import 'package:pulz/screens/questions1.dart';
import 'package:pulz/screens/measurement.dart';
import 'package:pulz/screens/tutorial_1.dart';
import 'package:pulz/screens/welcome.dart';

class AppRoutes {
  static String measurement = '/measurement';
  static String welcome = '/welcome';
  static String tutorial_1 = '/tutorial_1';
  static String questions1 = '/questions1';
  static String dashboard = '/dashboard';

  static List<GetPage> pages = [
    GetPage(
      name: measurement,
      page: () => MeasurementPage(),
    ),
    GetPage(
      name: welcome,
      page: () => const Welcome(),
    ),
    GetPage(
      name: tutorial_1,
      page: () => const Tutorial1(),
    ),
    GetPage(name: questions1, page: () => Questions1()),
    GetPage(name: dashboard, page: () => const Dashboard()),
  ];
}

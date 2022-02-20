import 'package:get/get.dart';
import 'package:pulz/screens/dashboard.dart';
import 'package:pulz/screens/finished.dart';
import 'package:pulz/screens/measurement.dart';
import 'package:pulz/screens/tutorial_1.dart';
import 'package:pulz/screens/welcome.dart';

class AppRoutes {
  static String measurement = '/measurement';
  static String welcome = '/welcome';
  static String tutorial_1 = '/tutorial_1';
  static String finished = '/finished';
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
    GetPage(name: finished, page: () => Finished()),
    GetPage(name: dashboard, page: () => const Dashboard()),
  ];
}

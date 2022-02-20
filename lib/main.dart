import 'package:path/path.dart';
import 'package:pulz/app_export.dart';
import 'package:pulz/routes/app_routes.dart';
import 'package:sqflite_common/sqflite_dev.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // only for debug
  await databaseFactory.setLogLevel(sqfliteLogLevelVerbose);
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'database1.db');
  //await deleteDatabase(path);
  final database = await openDatabase(
    path,
    onCreate: createDb,
    version: 1,
  );
  Get.put(database);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pulz',
      theme: lightTheme,
      initialRoute: AppRoutes.welcome,
      getPages: AppRoutes.pages,
    );
  }
}

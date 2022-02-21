import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'app_export.dart';

class CommonButton extends StatelessWidget {
  final String name;
  final String page;
  Function action = () {};

  CommonButton({Key? key, required this.name, required this.page})
      : super(key: key);
  CommonButton.action(
      {Key? key, required this.name, required this.page, required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: ElevatedButton(
        onPressed: () {
          action();
          Get.toNamed(page);
        },
        child: Text(name),
      ),
    );
  }
}

class CommonActionButton extends StatelessWidget {
  final String name;
  final String page;

  CommonActionButton({Key? key, required this.name, required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: ElevatedButton(
        onPressed: () async {
          Database database = Get.find();
          Measurement measurement = Get.find();
          await database.insert('measurements', measurement.toMap());
/*
          final directory = await getApplicationDocumentsDirectory();
          final file = File('$directory/data.csv');
          file.writeAsString(measurement.data.toString());

          http.post(
            Uri.parse('52773-1-5b2c2b30.labs.learning.intersystems.com/upload'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: json.encode(measurement.toMap()),
          );
*/
          Get.toNamed(page);
        },
        child: Text(name),
      ),
    );
  }
}

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xfff2fcfc),
  brightness: Brightness.light,
  primaryColor: const Color(0xff213d69),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        fixedSize: const Size(220, 50),
        primary: const Color(0xff213d69),
        onPrimary: const Color(0xfff2fcfc)),
  ),
  textTheme: const TextTheme(
      headline1: TextStyle(
          color: Color(0xff213d69),
          fontSize: 32,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700),
      bodyText2: TextStyle(
        color: Color(0xff213d69),
        fontFamily: 'Inter',
      ),
      headline3: TextStyle(
        color: Color(0xFF63B3E1),
        fontSize: 14,
        fontFamily: 'Inter',
      )),
);

ThemeData seedTheme = ThemeData(
    colorScheme:
        ColorScheme.fromSeed(seedColor: Colors.red, primary: Colors.green));

ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xff213d69),
    brightness: Brightness.light,
    primaryColor: const Color(0xfff2fcfc),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          fixedSize: const Size(220, 50),
          primary: Colors.white,
          onPrimary: const Color(0xff213d69)),
    ));

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);

  SensorValue.fromJson(Map<String, dynamic> json)
      : time = DateTime.parse(json['time']),
        value = json['value'];

  Map<String, dynamic> toJson() {
    return {
      'time': time.toString(),
      'value': value,
    };
  }
}

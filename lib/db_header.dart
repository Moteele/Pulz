import 'dart:convert';

import 'app_export.dart';

class Measurement {
  int? id;
  DateTime? time;
  List<SensorValue> data = [];
  int? bpm;

  Measurement();
  Measurement.args(
      {required this.id,
      required this.time,
      required this.data,
      required this.bpm});

  Map<String, dynamic> toMap() {
    return <String, Object?>{
      'id': id,
      'time': time.toString(),
      'data': json.encode(data),
      'bpm': bpm,
    };
  }

  static Future<List<Measurement>> getMeasurements(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('measurements');

    return List.generate(maps.length, (i) {
      return Measurement.args(
          id: maps[i]['id'],
          time: DateTime.parse(maps[i]['time']),
          data: List<SensorValue>.from(json.decode(maps[i]['data'])),
          bpm: maps[i]['bpm']);
    });
  }
}

void createDb(Database db, int version) async {
  Batch batch = db.batch();
  //batch.execute("CREATE TABLE situations(id INTEGER PRIMARY KEY, name TEXT);");
  batch.execute(
      "CREATE TABLE measurements(id INTEGER PRIMARY KEY, time TEXT, data TEXT, bpm INT)");
  await batch.commit(noResult: true);
}

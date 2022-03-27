import 'dart:convert';
import 'app_export.dart';

class Measurement {
  int? id;
  DateTime? time;
  List<SensorValue> data = [];
  int? bpm;
  //int? symptoms_id;

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
          data: (json.decode(maps[i]['data']) as List)
              .map((i) => SensorValue.fromJson(i))
              .toList(),
          bpm: maps[i]['bpm']);
    });
  }

  static final Map<String, dynamic> symptoms = {
    "responseCode": "1",
    "responseText": "Příznaky",
    "responseBody": [
      {"category_id": 1, "category_name": "Žádné"},
      {"category_id": 2, "category_name": "Rychlý srdeční tep"},
      {"category_id": 3, "category_name": "Nepravidelný srdeční rytmus"},
      {"category_id": 4, "category_name": "Únava"},
      {"category_id": 5, "category_name": "Dušnost"},
      {"category_id": 6, "category_name": "Tlak nebo bolest na hrudi"},
      {"category_id": 7, "category_name": "Studený pot"},
    ],
    "responseTotalResult": 7
  };
}

void createDb(Database db, int version) async {
  Batch batch = db.batch();
  batch.execute(
      "CREATE TABLE measurements(id INTEGER PRIMARY KEY, time TEXT, data TEXT, bpm INT)");
  //batch.execute("CREATE TABLE symptoms(id INTEGER PRIMARY KEY, measurement_id INTEGER, FOREIGN KEY(measurement_id) REFERENCES measurements(id))");
  await batch.commit(noResult: true);
}

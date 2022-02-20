import '../app_export.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Database db = Get.find();
  @override
  Widget build(BuildContext context) {
    Future<List<Measurement>> _measures = Measurement.getMeasurements(db);
    return FutureBuilder<List<Measurement>>(
        future: _measures,
        builder:
            (BuildContext context, AsyncSnapshot<List<Measurement>> snapshot) {
          if (snapshot.hasData) {
            int _count = (snapshot.data?.length ?? 0);
            return ListView.builder(
                itemCount: _count,
                itemBuilder: (context, i) {
                  return Text(snapshot.data![i].data.toString());
                });
          }
          return Container();
        });
  }
}

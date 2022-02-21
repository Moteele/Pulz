import 'package:pulz/chart.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Má měření", style: Theme.of(context).textTheme.headline1),
          FutureBuilder<List<Measurement>>(
              future: _measures,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Measurement>> snapshot) {
                if (snapshot.hasData) {
                  int _count = (snapshot.data?.length ?? 0);
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: _count,
                      itemBuilder: (context, i) {
                        return Row(
                          children: [
                            Text(DateFormat('dd. MM. yyyy').format(
                                snapshot.data![i].time ?? DateTime.now())),
                            SizedBox(
                                width: 200,
                                height: 120,
                                child: Chart(snapshot.data![i].data)),
                          ],
                        );
                      });
                }
                return Container();
              }),
          CommonButton(name: 'Nové měření', page: '/tutorial_1'),
        ],
      ),
    );
  }
}

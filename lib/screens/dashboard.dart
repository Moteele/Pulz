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
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Historie měření",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            Flexible(
              flex: 1,
              child: FutureBuilder<List<Measurement>>(
                  future: _measures,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Measurement>> snapshot) {
                    if (snapshot.hasData) {
                      int _count = (snapshot.data?.length ?? 0);
                      return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shrinkWrap: true,
                          itemCount: _count,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                                child: Container(
                                  height: 120,
                                  padding: const EdgeInsets.all(5),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(DateFormat('dd. MM. yyyy | hh:mm')
                                          .format(snapshot.data![i].time ??
                                              DateTime.now())),
                                      SizedBox(
                                          height: 110,
                                          width: 180,
                                          child: Chart(snapshot.data![i].data))
                                    ],
                                  ),
                                ),
                                onTap: () {});
                          });
                    }
                    return Container();
                  }),
            ),
            const Divider(
              height: 5,
            ),
            CommonButton(name: 'Nové měření', page: '/tutorial_1')
          ],
        ),
      ),
    );
  }
}
